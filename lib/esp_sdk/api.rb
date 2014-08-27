module EspSdk
  class Api
    attr_reader :end_points
    def initialize(token=Configure.token, email=Configure.email, version='v1')
      @token      = token
      @email      = email
      @version    = version
      @end_points = []
      define_methods
    end


    private

    def define_methods
      end_points = EspSdk::EndPoints.constants - [:Base]

      end_points.each do |end_point|
        name = end_point.to_s.underscore
        define_singleton_method name do |*args|
          return instance_variable_get(:"@#{name}") if instance_variable_get(:"@#{name}").present?
          instance_variable_set(:"@#{name}", EspSdk::EndPoints.const_get(end_point).new(@token, @email, @version))
        end

        @end_points << send(name)
      end
    end
  end
end