module EspSdk
  module EndPoints
    class Signatures < Base
      def run(params={})
        submit(run_url, :Post, params)
      end

      def names
        submit(name_url, :Get)
      end

      private

        def run_url
          "#{config.uri}/#{config.version}/#{self.class.to_s.demodulize.underscore}/run"
        end

        def name_url
          base_url + '/signature_names'
        end
    end
  end
end