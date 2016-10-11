module ESP
  class SubOrganization < ESP::Resource
    # The organization this sub organization belongs to.
    #
    # @return [ESP::Organization]
    belongs_to :organization, class_name: 'ESP::Organization'

    # The collection of teams that belong to the sub organization.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Team>]
    has_many :teams, class_name: 'ESP::Team'

    # The collection of external_accounts that belong to the sub organization.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::ExternalAccount>]
    has_many :external_accounts, class_name: 'ESP::ExternalAccount'

    # The collection of reports that belong to the sub organization.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Report>]
    has_many :reports, class_name: 'ESP::Report'

    # @!method self.where(clauses = {}
    #   Return a paginated SubOrganization list filtered by search parameters
    #
    #   *call-seq* -> +super.where(clauses = {})+
    #
    #   @param clauses [Hash] A hash of attributes with appended predicates to search, sort and include.
    #     ===== Valid Clauses
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#sub-organization-attributes] for valid arguments
    #   @return [ActiveResource::PaginatedCollection<ESP::SubOrganization>]

    # @!method self.find(id, options = {})
    #   Find a SubOrganization by id
    #
    #   *call-seq* -> +super.find(id, options = {})+
    #
    #   @param id [Integer, Numeric, #to_i] Required ID of the sub organization to retrieve.
    #   @param options [Hash] Optional hash of options.
    #     ===== Valid Options
    #
    #     +include+ | The list of associated objects to return on the initial request.
    #
    #     ===== Valid Includable Associations
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#sub-organization-attributes] for valid arguments
    #   @return [ESP::SubOrganization]

    # @!method self.all
    #   Return a paginated SubOrganization list
    #
    #   @return [ActiveResource::PaginatedCollection<ESP::SubOrganization>]

    # @!method self.create(attributes = {})
    #   Create a SubOrganization.
    #   *call-seq* -> +super.create(attributes={})+
    #
    #   @param attributes [Hash] Required hash of run arguments.
    #     ===== Valid Attributes
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#sub-organization-create] for valid arguments
    #   @return [ESP::SubOrganization]
    #   @example
    #    sub_organization = ESP::SubOrganization.create(name: "Sub Organization Name")

    # @!method save(attributes = {})
    #   Create and update a SubOrganization.
    #
    #   @param attributes [Hash] Required hash of run arguments.
    #     ===== Valid Attributes
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#sub-organization-create] for valid arguments
    #   @return [Boolean]
    #   @example
    #    sub_organization = ESP::SubOrganization.new(name: "Sub Organization Name")
    #    sub_organization.save

    # @!method destroy
    #   Delete a SubOrganization.
    #
    #   @return [self]
  end
end
