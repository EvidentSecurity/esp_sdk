module EspSdk
  module EndPoints
    class Dashboard < Base
      def timewarp(params = {})
        validate_timewarp_params(params.keys)
        submit(timewarp_url, :post, params)
      end

      private

      def timewarp_url
        "#{base_url}/timewarp"
      end

      def validate_timewarp_params(keys)
        valid_timewarp_params = [:time]

        # Check that all the valid params are present
        valid_timewarp_params.each do |param|
          fail MissingAttribute, "Missing required attribute #{param}" unless keys.include?(param)
        end

        # Check for invalid params
        keys.each do |key|
          fail UnknownAttribute, "Unknown attribute #{key}" unless valid_timewarp_params.include?(key)
        end
      end
    end
  end
end
