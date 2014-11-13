module EspSdk
  module EndPoints
    class SubOrganizations < Base
      private

      def required_params
        [:name, :id]
      end

      def valid_params
        [:organization_id]
      end
    end
  end
end
