module EspSdk
  module EndPoints
    class CustomSignatures < Base
      def run(params={})
        validate_run_params(params)
        submit(run_url, :Post, params)
      end

      private

        def run_url
          "#{config.uri}/#{config.version}/#{self.class.to_s.demodulize.underscore}/run"
        end

        def required_params
          [:id, :signature, :name, :risk_level]
        end

        def valid_params
          [:description, :active, :resolution]
        end

        def validate_run_params(params)
          valid_params = [:custom_signature_id, :regions, :external_account_id]
          keys         = params.keys

          # Check that all the valid params are present
          valid_params.each do |param|
            raise EspSdk::Exceptions::MissingAttribute, "Missing required attribute #{param}" unless keys.include?(param)
          end

          # Check for invalid params
          keys.each do |key|
            raise EspSdk::Exceptions::UnknownAttribute, key unless valid_params.include?(key)
          end
        end
    end
  end
end