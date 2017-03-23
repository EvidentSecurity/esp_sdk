module ESP
  class CustomSignature
    class Definition < ESP::Resource
      self.prefix += "custom_signature_"

      belongs_to :custom_signature, class_name: 'ESP::CustomSignature'
      has_many :results, class_name: 'ESP::CustomSignature::Result'

      # @return [Net::HTTPSuccess, false]
      def activate
        patch(:activate).tap do |response|
          load_attributes_from_response(response)
        end
      rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid, ActiveResource::UnauthorizedAccess, ActiveResource::ForbiddenAccess => error
        load_remote_errors(error, true)
        self.code = error.response.code
        false
      end

      # @return [Net::HTTPSuccess, false]
      def archive
        patch(:archive).tap do |response|
          load_attributes_from_response(response)
        end
      rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid, ActiveResource::UnauthorizedAccess, ActiveResource::ForbiddenAccess => error
        load_remote_errors(error, true)
        self.code = error.response.code
        false
      end

      # @!method self.where(clauses = {})
      #   Return a list filtered by search parameters
      #
      #   *call-seq* -> +super.where(clauses = {})+
      #
      #   @param clauses [Hash] A hash of attributes with appended predicates to search, sort and include.
      #     ===== Valid Clauses
      #
      #     See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-definition-attributes] for valid arguments
      #   @return [ActiveResource::PaginatedCollection<ESP::CustomSignature::Definition>]

      # @!method self.find(id)
      #   Find a CustomSignature::Definition by id
      #
      #   *call-seq* -> +find(id, options = {})+
      #
      #   @overload find(id)
      #   @overload find(id, options = {})
      #     @param options | Optional | A hash of options
      #       ===== Valid Options
      #
      #       +include+ | The list of associated objects to return on the initial request.
      #
      #       ===== Valid Includable Associations
      #
      #       See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-definition-attributes] for valid arguments
      #   @param id [Integer, Numeric, #to_i] Required ID of the custom signature definition to retrieve
      #   @return [ESP::CustomSignature::Definition]

      # @!method self.all
      #   Return a paginated list
      #
      #   @return [ActiveResource::PaginatedCollection<ESP::CustomSignature::Definition>]

      # @!method self.create(attributes = {})
      #   Create a CustomSignature::Definition
      #   *call-seq* -> +super.create(attributes={})+
      #
      #   @param attributes [Hash] Required hash of custom signature definition attributes.
      #     ===== Valid Attributes
      #
      #     See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-definition-create] for valid arguments
      #   @return [ESP::CustomSignature::Definition
      #   @example
      #     definition = ESP::CustomSignature::Definition.create(custom_signature_id: 1)

      # @!method save
      #   Create or update a CustomSignature::Definition
      #
      #   ===== Valid Attributes
      #
      #   See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-definition-create] for valid arguments
      #
      #   @return [Boolean]
      #   @example
      #    definition = ESP::CustomSignature::Definition.new(custom_signature_id: 1)
      #    definition.save

      # @!method destroy
      #   Delete a CustomSignature::Definition
      #
      #   @return [self]
    end
  end
end
