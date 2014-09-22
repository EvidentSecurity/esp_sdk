module EspSdk
  module EndPoints
    class Signatures < Base
      def run(params={})
        validate_run_params(params)
        submit(run_url, :Post, params)
      end

      def names
        submit(name_url, :Get)
      end

      private

        def required_params
          [:id, :name, :identifier, :provider, :scope, :risk_level, :description, :resolution, :service]
        end

        def run_url
          "#{config.uri}/#{config.version}/#{self.class.to_s.demodulize.underscore}/run"
        end

        def name_url
          base_url + '/signature_names'
        end

        def validate_run_params(options)
          valid_params = [:signature_name, :regions, :external_account_id]
          keys         = options.keys

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