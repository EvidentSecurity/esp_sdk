require 'rest_client'
require_relative 'extensions/rest_client/request'

module EspSdk
  # Client class for our endpoints. Every endpoint gets its own client.
  class Client
    attr_reader :config, :errors

    def initialize(config)
      @config  = config
    end

    def connect(url, type = :get, payload = {})
      payload = { payload_key => payload } if payload.present?

      begin
        if type == :get || type == :delete
          if payload.present?
            response = RestClient.send(type, url, headers.merge(params: payload))
          else
            response = RestClient.send(type, url, headers)
          end
        else
          # The rest of our actions will require a payload
          fail MissingAttribute, 'Missing required attributes' if payload.blank?
          response = RestClient.send(type, url, payload, headers)
        end
      rescue RestClient::Unauthorized => e
        fail EspSdk::Unauthorized, 'Unauthorized request'
      rescue RestClient::UnprocessableEntity => e
        response = e.response
        body     = JSON.load(response.body) if response.body.present?
        check_errors(JSON.load(body))
      end

      response
    end

    private

    def headers
      @headers ||= { 'Authorization' => @config.token, 'Authorization-Email' => @config.email, 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    end

    def payload_key
      @payload_key ||= self.class.to_s.demodulize.singularize.underscore
    end

    def check_errors(body)
      @errors  = body['errors'] if body.present? && body.is_a?(Hash) && body['errors'].present?
      return unless @errors.present?

      if @errors.select { |error| error.to_s.include?('Token has expired') }.present?
        fail TokenExpired, 'Token has expired'
      elsif (error = @errors.select { |error| error.to_s.include?('Record not found') }[0]).present?
        fail RecordNotFound, error
      else
        fail EspSdk::Exception, "#{@errors.join('. ')}"
      end
    end
  end
end
