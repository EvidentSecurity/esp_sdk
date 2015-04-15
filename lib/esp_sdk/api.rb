module EspSdk
  class Api
    attr_reader :end_points, :config

    def initialize(options = {})
      options[:email] ||= options_errors(:email)
      options_errors(:password) if options[:token].blank? && options[:password].blank?
      @config     = Configure.new(options)
      @end_points = []
      define_methods
    end

    private

    def define_methods
      end_points = EspSdk::EndPoints.constants - [:Base]

      end_points.each do |end_point|
        name = end_point.to_s.underscore
        define_singleton_method name do
          return instance_variable_get(:"@#{name}") if instance_variable_get(:"@#{name}").present?
          instance_variable_set(:"@#{name}", EspSdk::EndPoints.const_get(end_point).new(config))
        end

        @end_points << send(name)
      end
    end

    def options_errors(option)
      ENV["ESP_#{option.upcase}"] || fail(EspSdk::MissingAttribute, "Missing required #{option}")
    end
  end
end
