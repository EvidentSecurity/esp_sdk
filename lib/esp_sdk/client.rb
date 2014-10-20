require 'net/http'
require 'uri'

module EspSdk
  class Client
    attr_reader :config, :errors

    def initialize(config)
      @config  = config
    end

    def connect(url, type=:Get, body={})
      begin
        uri          = URI(url)
        uri.query    = { self.class.to_s.demodulize.singularize.underscore => body }.to_query if body.present?
        http         = Net::HTTP.new(uri.host, uri.port)
        request      = Net::HTTP.const_get(type).new uri, { 'Authorization' => @config.token, 'Authorization-Email' => @config.email, 'Content-Type' => 'json/text' }
        http.start
        response = http.request(request)
      rescue Exception => e
        puts "@@@@@@@@@ #{__FILE__}:#{__LINE__} \n********** e.message = " + e.message.inspect
        puts "@@@@@@@@@ #{__FILE__}:#{__LINE__} \n********** e.backtrace.join('\n') = " + e.backtrace.join("\n")
      ensure
        http.finish if http.active?
      end

      # Raise an error if we do not have a HTTPSuccess 2xx for our response
      if response.kind_of? Net::HTTPSuccess
        # Set the errors
        @errors = Client.convert_json(response.body)['errors']

        if @errors.present?
          if @errors.include?('Token has expired')
            raise EspSdk::Exceptions::TokenExpired, 'Token has expired'
          elsif @errors.include?('Record not found')
            raise EspSdk::Exceptions::RecordNotFound, 'Record not found'
          end
        end
      else
        response.error!
      end

      response
    end

    # Recursively convert json
    def self.convert_json(json)
      if json.is_a?(String)
        convert_json(JSON.load(json))
      elsif json.is_a?(Array)
        json.each_with_index do |value, index|
          json[index] = convert_json(value)
        end
      else
        if json.is_a?(Array)
          json
        else
          ActiveSupport::HashWithIndifferentAccess.new(json)
        end
      end
    end
  end
end