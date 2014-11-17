module EspSdk
  module EndPoints
    class ExternalAccounts < Base
      def generate_external_id
        SecureRandom.uuid
      end
    end
  end
end
