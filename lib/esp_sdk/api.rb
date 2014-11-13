module EspSdk
  class Api
    attr_reader :end_points, :config

    def initialize(options = {})
      fail ::MissingAttribute, 'Missing required email'    if options[:email].blank?
      fail ::MissingAttribute, 'Missing required password' if options[:password].blank? && options[:token].blank?
      @config       = Configure.new(options)
      @end_points   = []

      # Get the token if one was not supplied in the options
      if @config.token.blank?
        @config.token = options.delete(:password)
        get_token
      else
        validate_token
      end

      define_methods
    end

    private

    def define_methods
      end_points = EspSdk::EndPoints.constants - [:Base]

      end_points.each do |end_point|
        name = end_point.to_s.underscore
        define_singleton_method name do
          return instance_variable_get(:"@#{name}") if instance_variable_get(:"@#{name}").present?
          instance_variable_set(:"@#{name}", EspSdk::EndPoints.const_get(end_point).new(@config))
        end

        @end_points << send(name)
      end
    end

    def get_token
      token_setup
    end

    def validate_token
      token_setup('valid')
    end

    def token_setup(end_point = 'new')
      client        = Client.new(@config)
      response      = client.connect("#{config.uri}/#{config.version}/token/#{end_point}")
      user          = Client.convert_json(response.body)
      @config.token = user['authentication_token']
      @config.token_expires_at = user['token_expires_at'].to_s.to_datetime.to_s.in_time_zone('UTC') || 1.hour.from_now.to_datetime.in_time_zone('UTC')
    end
  end
end
