module ESP
  class ExternalAccount < ESP::Resource
    # The organization the external account belongs to.
    #
    # @return [ESP::Organization]
    belongs_to :organization, class_name: 'ESP::Organization'

    # The sub_organization the external account belongs to.
    #
    # @ return [ESP::SubOrganization]
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'

    # The team the external account belongs to.
    #
    # @return [ESP::Team]
    belongs_to :team, class_name: 'ESP::Team'

    # The collection of reports that belong to the team.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Report>]
    has_many :reports, class_name: 'ESP::Report'

    # Helper to generate an external id.
    # Called automatically when creating an ExternalAccount if +external_id+ is not already set.
    #
    # @return [String]
    def generate_external_id
      SecureRandom.uuid
    end

    # This instance method is called by the #save method when new? is true.
    #
    # @private
    def create
      attributes['external_id'] ||= generate_external_id
      super
    end

    # Returns a collection of scan_intervals for the external account
    #
    # @return [ActiveResource::PaginatedCollection<ESP::ScanInterval>]
    # @example
    #   external_account = ESP::ExternalAccount.find(345)
    #   scan_intervals = external_account.scan_intervals
    def scan_intervals
      ESP::ScanInterval.for_external_account(id)
    end

    # @!method self.where(clauses = {})
    #   Return a paginated ExternalAccount list filtered by search parameters
    #
    #   *call-seq* -> +super.where(clauses = {})+
    #
    #   @param clauses [Hash] A hash of attributes with appended predicates to search, sort and include.
    #     ===== Valid Clauses
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#external-account-attributes] for valid arguments
    #   @return [ActiveResource::PaginatedCollection<ESP::ExternalAccount>]

    # @!method self.find(id)
    #   Find an ExternalAccount by id
    #
    #   *call-seq* -> +super.find(id, options = {})+
    #
    #   @overload find(id)
    #   @overload find(id, options = {})
    #     @param options [Hash] An optional hash of options.
    #       ===== Valid Options
    #
    #       +include+ | The list of associated objects to return on the initial request.
    #
    #       ===== Valid Includable Associations
    #
    #       See {API documentation}[http://api-docs.evident.io?ruby#external-account-attributes] for valid arguments
    #   @param id [Integer, Numberic, #to_i] Required ID of the external account to retrieve.
    #   @return [ESP::ExternalAccount]

    # @!method self.all
    # Return a paginated list
    #
    # @return [ActiveResource::PaginatedCollection<ESP::ExternalAccount>]

    # @!method self.create(attributes = {})
    #   Create an ExternalAccount.
    #   *call-seq* -> +super.create(attributes={})+
    #
    #   @param attributes [Hash] Required hash of external account attributes.
    #     ===== Valid Attributes
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#external-account-create] for valid arguments
    #   @return [ESP::ExternalAccount]
    #   @example
    #     external_account = ESP::ExternalAccount.create(arn: 'arn:from:aws', external_id: 'c40e6af4-a5a0-422a-9a42-3d7d236c3428', sub_organization_id: 4, team_id: 8)

    # @!method save
    #   Create or update an ExternalAccount.
    #
    #   ===== Valid Attributes
    #
    #   See {API documentation}[http://api-docs.evident.io?ruby#external-account-create] for valid arguments
    #
    #   @return [Boolean]
    #   @example
    #     external_account = ESP::ExternalAccount.new(arn: 'arn:from:aws', external_id: 'c40e6af4-a5a0-422a-9a42-3d7d236c3428', sub_organization_id: 4, team_id: 8)
    #     external_account.save

    # @!method destroy
    #   Delete an ExternalAccount
    #
    #   @return [self]
  end
end
