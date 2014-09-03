module EspSdk
  class Api
    attr_reader :end_points, :config

    def initialize(options={})
      raise MissingAttribute, 'Missing required email' unless options[:email].present?
      raise MissingAttribute, 'Missing required email' unless options[:password].present?
      @config       = Configure.new(options)
      @config.token = options.delete(:password)
      @end_points   = []

      get_token
      define_methods
    end


    private

      def define_methods
        end_points = EspSdk::EndPoints.constants - [:Base]

        end_points.each do |end_point|
          name = end_point.to_s.underscore
          define_singleton_method name do |*args|
            return instance_variable_get(:"@#{name}") if instance_variable_get(:"@#{name}").present?
            instance_variable_set(:"@#{name}", EspSdk::EndPoints.const_get(end_point).new(@config))
          end

          @end_points << send(name)
        end
      end

      def get_token
        client        = Client.new(@config)
        response      = client.connect("#{config.uri}/#{config.version}/token/new")
        user          = Client.convert_json(response.body)
        @config.token = user['authentication_token']
        @config.token_expires_at = user['token_expires_at'].to_datetime.in_time_zone('UTC')
      end
  end
end