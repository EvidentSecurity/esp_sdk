module EspSdk
  module EndPoints
    class Dashboard < Base
      def timewarp(params = {})
        validate_timewarp_params(params.keys)
        submit(timewarp_url, :post, params)
      end

      def valid_timewarp_params
        [:time]
      end

      private

      def timewarp_url
        "#{config.uri}/#{config.version}/#{self.class.to_s.demodulize.underscore}/timewarp"
      end

      def validate_timewarp_params(keys)
        # Check that all the valid params are present
        valid_timewarp_params.each do |param|
          fail ::MissingAttribute, "Missing required attribute #{param}" unless keys.include?(param)
        end

        # Check for invalid params
        keys.each do |key|
          fail ::UnknownAttribute, key unless valid_timewarp_params.include?(key)
        end
      end
    end
  end
end
