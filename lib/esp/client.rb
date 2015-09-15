require 'rest_client'
require_relative 'extensions/rest_client/request'

module ESP
  # Client class for our endpoints. Every endpoint gets its own client.
  class Client
    attr_reader :config, :errors

    # def initialize(config)
    #   @config = config
    # end

    # def connect(url, type = :get, payload = {})
    #   build_and_send_request(url, type, payload)
    # rescue RestClient::Unauthorized
    #   raise ESP::Unauthorized, 'Unauthorized request'
    # rescue RestClient::UnprocessableEntity => e
    #   body = JSON.load(e.response.body) if e.response.body.present?
    #   check_errors(body)
    # end

    private

    def build_and_send_request(url, type, payload)
      if type == :get || type == :delete
        headers[:params] = payload_hash(payload) if payload.present?
        RestClient.send(type, url, headers)
      else
        # The rest of our actions will require a payload
        fail MissingAttribute, 'Missing required attributes' if payload.blank?
        RestClient.send(type, url, payload_hash(payload), headers)
      end
    end

    def headers
      @headers ||= { 'Authorization' => @config.token, 'Authorization-Email' => @config.email, 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    end

    def payload_key
      @payload_key ||= self.class.to_s.demodulize.singularize.underscore
    end

    def payload_hash(payload)
      { payload_key => payload } if payload.present?
    end

    def check_errors(body)
      return if body.blank? || !body.is_a?(Hash) || body['errors'].blank?
      @errors = body['errors']

      fail TokenExpired, 'Token has expired' if @errors.any? { |error| error.to_s.include?('Token has expired') }
      fail RecordNotFound, 'Record not found' if @errors.any? { |error| error.to_s.include?('Record not found') }
      fail ESP::Exception, "#{@errors.join('. ')}"
    end
  end
end
