module EspSdk
  module EndPoints
    class CustomSignatures < Base
      def run(params = {})
        validate_run_params(valid_run_params, params.keys)
        submit(run_url, :post, params)
      end

      def run_raw(params = {})
        validate_run_params(valid_run_raw_params, params.keys)
        submit(run_url, :post, params)
      end

      private

      def run_url
        "#{config.uri}/#{config.version}/#{self.class.to_s.demodulize.underscore}/run"
      end

      def valid_run_params
        [:id, :regions, :external_account_id]
      end

      def valid_run_raw_params
        [:signature, :regions, :external_account_id]
      end

      def validate_run_params(valid_params, keys)
        # Check that all the valid params are present
        valid_params.each do |param|
          fail ::MissingAttribute, "Missing required attribute #{param}" unless keys.include?(param)
        end

        # Check for invalid params
        keys.each do |key|
          fail ::UnknownAttribute, key unless valid_params.include?(key)
        end
      end
    end
  end
end
