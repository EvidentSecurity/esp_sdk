module EspSdk
  module EndPoints
    class ContactRequests < Base

      private

        def required_params
          [:id, :title, :request_type, :description]
        end
    end
  end
end