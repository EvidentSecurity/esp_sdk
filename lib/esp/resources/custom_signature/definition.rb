module ESP
  class CustomSignature
    class Definition < ESP::Resource
      self.prefix += "custom_signature_"

      belongs_to :custom_signature, class_name: 'ESP::CustomSignature'
      has_many :results, class_name: 'ESP::CustomSignature::Result'

      def activate
        patch(:activate).tap do |response|
          load_attributes_from_response(response)
        end
      rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid, ActiveResource::UnauthorizedAccess => error
        load_remote_errors(error, true)
        self.code = error.response.code
        false
      end

      def archive
        patch(:archive).tap do |response|
          load_attributes_from_response(response)
        end
      rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid, ActiveResource::UnauthorizedAccess => error
        load_remote_errors(error, true)
        self.code = error.response.code
        false
      end

      # :singleton-method: where
      # Return a paginated CustomSignature::Definition list filtered by search parameters
      #
      # ==== Parameters
      #
      # +clauses+ | Hash of attributes with appended predicates to search, sort and include.
      #
      # ===== Valid Clauses
      #
      # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-definition-attributes] for valid arguments
      #
      # :call-seq:
      #  where(clauses = {})

      ##
      # :singleton-method: find
      # Find a CustomSignature::Definition by id
      #
      # ==== Parameter
      #
      # +id+ | Required | The ID of the custom signature definition to retrieve
      #
      # +options+ | Optional | A hash of options
      #
      # ===== Valid Options
      #
      # +include+ | The list of associated objects to return on the initial request.
      #
      # ===== Valid Includable Associations
      #
      # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-definition-attributes] for valid arguments
      #
      # :call-seq:
      #  find(id, options = {})

      # :singleton-method: all
      # Return a paginated CustomSignature::Definition list

      # :singleton-method: create
      # Create a CustomSignature::Definition
      # :call-seq:
      #   create(attributes={})
      #
      # ==== Parameter
      #
      # +attributes+ | Required | A hash of custom signature definition attributes
      #
      # ===== Valid Attributes
      #
      # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-definition-create] for valid arguments
      #
      # ==== Example
      #
      #  definition = ESP::CustomSignature::Definition.create(custom_signature_id: 1)

      # :method: save
      # Create or update a CustomSignature::Definition
      #
      # ===== Valid Attributes
      #
      # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-definition-create] for valid arguments
      #
      # ==== Example
      #
      #  definition = ESP::CustomSignature::Definition.new(custom_signature_id: 1)
      #  definition.save

      # :method: destroy
      # Delete a CustomSignature::Definition
    end
  end
end
