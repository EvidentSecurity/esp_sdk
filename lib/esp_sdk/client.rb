require 'rest_client'

module EspSdk
  class Client
    attr_reader :config, :errors

    def initialize(config)
      @config  = config
    end

    def connect(url, type=:get, payload={})
      headers = { 'Authorization' => @config.token, 'Authorization-Email' => @config.email, 'Content-Type' => 'json/text' }
      payload = { self.class.to_s.demodulize.singularize.underscore => payload } if payload.present?
      
      if type == :get || type == :delete
        if payload.present?
          response = RestClient.send(type, url, headers.merge(params: payload))
        else
          response = RestClient.send(type, url, headers)
        end
      else
        response = RestClient.send(type, url, payload, headers)
      end

      body     = Client.convert_json(response.body)
      @errors  = body['errors'] if body.present? && body.kind_of?(Hash) && body['errors'].present?

      if @errors.present?
        if @errors.include?('Token has expired')
          raise EspSdk::Exceptions::TokenExpired, 'Token has expired'
        elsif @errors.include?('Record not found')
          raise EspSdk::Exceptions::RecordNotFound, 'Record not found'
        end
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
