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
      ensure
        http.finish
      end

      # Raise an error if we do not have a HTTPSuccess 2xx for our response
      unless response.kind_of? Net::HTTPSuccess
        # Set the errors
        @errors = Client.convert_json(response.body)['errors']
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
        json
      end
    end
  end
end