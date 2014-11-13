module EspSdk
  module EndPoints
    class Services < Base
      private

      def required_params
        [:id, :name, :code]
      end
    end
  end
end
