module EspSdk
  module EndPoints
    class Organizations < Base

      private

      def required_params
        [:id]
      end

      def valid_params
        [:name]
      end
    end
  end
end