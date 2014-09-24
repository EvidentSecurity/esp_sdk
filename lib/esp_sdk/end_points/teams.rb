module EspSdk
  module EndPoints
    class Teams < Base

      private

        def required_params
          [:id, :name, :sub_organization_id]
        end

        def valid_params
          [:organization_id]
        end
    end
  end
end