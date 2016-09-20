module ESP
  class CustomSignature < ESP::Resource
    autoload :Definition, File.expand_path(File.dirname(__FILE__) + '/custom_signature/definition')
    autoload :Result, File.expand_path(File.dirname(__FILE__) + '/custom_signature/result')

    # The organization this custom signature belongs to.
    #
    # @return [ESP::Organization]
    belongs_to :organization, class_name: 'ESP::Organization'
    # @return [ActiveResource::PaginatedCollection<ESP::CustomSignature::Definition>]
    has_many :definitions, class_name: 'ESP::CustomSignature::Definition'

    # The collection of teams that belong to the custom_signature.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Team>]
    def teams
      return attributes['teams'] if attributes['teams'].present?
      Team.where(custom_signatures_id_eq: id)
    end

    # Create a suppression for this custom signature.
    #
    # @param arguments [Hash] Required hash of signature suppression attributes
    #   ===== Valid Arguments
    #
    #   See {API documentation}[http://api-docs.evident.io?ruby#suppression-create] for valid arguments
    # @return [ESP::Suppression::Signature]
    # @example
    #   suppress(regions: ['us_east_1'], external_account_ids: [5], reason: 'My very good reason for creating this suppression')
    def suppress(arguments = {})
      arguments = arguments.with_indifferent_access
      ESP::Suppression::Signature.create(custom_signature_ids: [id], regions: Array(arguments[:regions]), external_account_ids: Array(arguments[:external_account_ids]), reason: arguments[:reason])
    end

    # @!method self.where(clauses = {})
    #   Find a list of custom signatures filtered by search parameters.
    #
    #   *call-seq* -> +super.where(clauses = {})+
    #
    #   @param clauses [Hash] Attributes with appended predicates to search, sort, and include.
    #     ===== Valid Clauses
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-attributes] for valid arguments
    #   @return [ActiveResource::PaginatedCollection<ESP::CustomSignature>]

    # @!method self.find(id, options = {})
    #   Find a CustomSignature by id
    #
    #   *call-seq* -> +super.find(id, options = {})+
    #
    #   @param id [Integer, Numeric, #to_i] Required ID of the custom signature to retrieve.
    #   @param options [Hash] Optional hash of options.
    #     ===== Valid Options
    #
    #     +include+ | The list of associated objects to return on the initial request.
    #
    #     ===== Valid Includable Associations
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-attributes] for valid arguments
    #   @return [ESP::CustomSignature]

    # @!method self.all
    #   Return a paginated CustomSignature list
    #
    #   @return [ActiveResource::PaginatedCollection<ESP::CustomSignature>]

    # @!method self.create(attributes = {})
    #   Create a CustomSignature
    #   *call-seq* -> +super.create(attributes={})+
    #
    #   @param attributes [Hash] Required hash of custom signature attributes.
    #     ===== Valid Attributes
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-create] for valid arguments
    #   @return [ESP::CustomSignature]
    #   @example
    #     custom_signature = ESP::CustomSignature.create(description: "A test custom signature.", identifier: "AWS::IAM::001", name: "Test Signature", risk_level: "Medium")

    # @!method save
    #   Create or update a CustomSignature
    #
    #   ===== Valid Attributes
    #
    #   See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-create] for valid arguments
    #
    #   @return [Boolean]
    #   @example
    #    custom_signature = ESP::CustomSignature.new(description: "A test custom signature.", identifier: "AWS::IAM::001", name: "Test Signature", risk_level: "Medium")
    #    custom_signature.save

    # @!method destroy
    #   Delete a CustomSignature
    #
    #   @return [self]
  end
end
