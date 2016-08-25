module ESP
  class CustomSignature
    class Result
      class Alert < ESP::Resource
        belongs_to :region, class_name: 'ESP::Region'
        belongs_to :external_account, class_name: 'ESP::ExternalAccount'
        belongs_to :custom_signature, class_name: 'ESP::CustomSignature'

        # Returns all the alerts for a custom signature result identified by the custom_signature_result_id parameter.
        #
        # @param custom_signature_result_id [Integer, Numeric, #to_i] Required ID of the custom signature result to retrieve alerts for
        # @return [ActiveResource::PaginatedCollection<ESP::CustomSignature::Result::Alert>]
        def self.for_result(custom_signature_result_id = nil)
          fail ArgumentError, "You must supply a custom signature result id." unless custom_signature_result_id.present?
          # call find_every directly since find is overriden/not implemented
          find_every(from: "#{prefix}custom_signature_results/#{custom_signature_result_id}/alerts.json")
        end

        # Not Implemented. You cannot search for CustomSignature::Result::Alert.
        #
        # Regular ARELlike methods are disabled.
        #
        # @return [void]
        def self.find(*)
          fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled. Use the .for_result method.'
        end

        # Not Implemented. You cannot search for CustomSignature::Result::Alert.
        #
        # Regular ARELlike methods are disabled.
        #
        # @return [void]
        def self.where(*)
          fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled. Use the .for_result method.'
        end

        # Not Implemented. You cannot create a CustomSignature::Result::Alert.
        #
        # @return [void]
        def create
          fail ESP::NotImplementedError
        end

        # Not Implemented. You cannot update a CustomSignature::Result::Alert.
        #
        # @return [void]
        def update
          fail ESP::NotImplementedError
        end

        # Not Implemented. You cannot destroy a CustomSignature::Result::Alert.
        #
        # @return [void]
        def destroy
          fail ESP::NotImplementedError
        end
      end
    end
  end
end
