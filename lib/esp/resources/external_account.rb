module ESP
  class ExternalAccount < ESP::Resource
    ##
    # The organization the external account belongs to.
    belongs_to :organization, class_name: 'ESP::Organization'

    ##
    # The sub_organization the external account belongs to.
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'

    ##
    # The team the external account belongs to.
    belongs_to :team, class_name: 'ESP::Team'

    # Helper to generate an external id.
    # Called automatically when creating an ExternalAccount if +external_id+ is not already set.
    def generate_external_id
      SecureRandom.uuid
    end

    # This instance method is called by the #save method when new? is true.
    def create # :nodoc:
      attributes['external_id'] ||= generate_external_id
      super
    end

    # Returns a collection of scan_intervals for the external account
    #
    # ==== Example
    #
    #   external_account = ESP::ExternalAccount.find(345)
    #   scan_intervals = external_account.scan_intervals
    def scan_intervals
      ESP::ScanInterval.for_external_account(id)
    end

    # :singleton-method: where
    # Return a paginated ExternalAccount list filtered by search parameters
    #
    # ==== Parameters
    #
    # +clauses+ | Hash of attributes with appended predicates to search, sort and include.
    #
    # ===== Valid Clauses
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#external-account-attributes] for valid arguments
    #
    # :call-seq:
    #  where(clauses = {})

    ##
    # :singleton-method: find
    # Find an ExternalAccount by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the external account to retrieve
    #
    # +options+ | Optional | A hash of options
    #
    # ===== Valid Options
    #
    # +include+ | The list of associated objects to return on the initial request.
    #
    # ===== Valid Includable Associations
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#external-account-attributes] for valid arguments
    #
    # :call-seq:
    #  find(id, options = {})

    # :singleton-method: all
    # Return a paginated CustomSignature list

    # :singleton-method: create
    # Create an ExternalAccount.
    # :call-seq:
    #   create(attributes={})
    #
    # ==== Parameter
    #
    # +attributes+ | Required | A hash of external account attributes
    #
    # ===== Valid Attributes
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#external-account-create] for valid arguments
    #
    # ==== Example
    #
    #  external_account = ESP::ExternalAccount.create(arn: 'arn:from:aws', external_id: 'c40e6af4-a5a0-422a-9a42-3d7d236c3428', sub_organization_id: 4, team_id: 8)

    # :method: save
    # Create or update an ExternalAccount.
    #
    # ===== Valid Attributes
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#external-account-create] for valid arguments
    #
    # ==== Example
    #
    #  external_account = ESP::ExternalAccount.new(arn: 'arn:from:aws', external_id: 'c40e6af4-a5a0-422a-9a42-3d7d236c3428', sub_organization_id: 4, team_id: 8)
    #  external_account.save

    # :method: destroy
    # Delete a CustomSignature
  end
end
