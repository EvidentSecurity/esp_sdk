module ESP
  class CustomSignature < ESP::Resource
    autoload :Definition, File.expand_path(File.dirname(__FILE__) + '/custom_signature/definition')
    autoload :Result, File.expand_path(File.dirname(__FILE__) + '/custom_signature/result')

    ##
    # The organization this custom signature belongs to.
    belongs_to :organization, class_name: 'ESP::Organization'
    has_many :definitions, class_name: 'ESP::CustomSignature::Definition'

    ##
    # The collection of teams that belong to the custom_signature.
    def teams
      return attributes['teams'] if attributes['teams'].present?
      Team.where(custom_signatures_id_eq: id)
    end

    # Create a suppression for this custom signature.
    #
    # ==== Parameter
    #
    # +arguments+ | Required | A hash of signature suppression attributes
    #
    # ===== Valid Arguments
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#suppression-create] for valid arguments
    #
    # ==== Example
    #   suppress(regions: ['us_east_1'], external_account_ids: [5], reason: 'My very good reason for creating this suppression')
    def suppress(arguments = {})
      arguments = arguments.with_indifferent_access
      ESP::Suppression::Signature.create(custom_signature_ids: [id], regions: Array(arguments[:regions]), external_account_ids: Array(arguments[:external_account_ids]), reason: arguments[:reason])
    end

    # :singleton-method: where
    # Return a paginated CustomSignature list filtered by search parameters
    #
    # ==== Parameters
    #
    # +clauses+ | Hash of attributes with appended predicates to search, sort and include.
    #
    # ===== Valid Clauses
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-attributes] for valid arguments
    #
    # :call-seq:
    #  where(clauses = {})

    ##
    # :singleton-method: find
    # Find a CustomSignature by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the custom signature to retrieve
    #
    # +options+ | Optional | A hash of options
    #
    # ===== Valid Options
    #
    # +include+ | The list of associated objects to return on the initial request.
    #
    # ===== Valid Includable Associations
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-attributes] for valid arguments
    #
    # :call-seq:
    #  find(id, options = {})

    # :singleton-method: all
    # Return a paginated CustomSignature list

    # :singleton-method: create
    # Create a CustomSignature
    # :call-seq:
    #   create(attributes={})
    #
    # ==== Parameter
    #
    # +attributes+ | Required | A hash of custom signature attributes
    #
    # ===== Valid Attributes
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-create] for valid arguments
    #
    # ==== Example
    #
    #  custom_signature = ESP::CustomSignature.create(description: "A test custom signature.", identifier: "AWS::IAM::001", name: "Test Signature", risk_level: "Medium")

    # :method: save
    # Create or update a CustomSignature
    #
    # ===== Valid Attributes
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-create] for valid arguments
    #
    # ==== Example
    #
    #  custom_signature = ESP::CustomSignature.new(description: "A test custom signature.", identifier: "AWS::IAM::001", name: "Test Signature", risk_level: "Medium")
    #  custom_signature.save

    # :method: destroy
    # Delete a CustomSignature
  end
end
