module ESP
  class Organization < ESP::Resource
    # The collection of teams that belong to the organization.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Team>]
    has_many :teams, class_name: 'ESP::Team'

    # The collection of sub_organizations that belong to the organization.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::SubOrganization>]
    has_many :sub_organizations, class_name: 'ESP::SubOrganization'

    # The collection of users that belong to the organization.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::User>]
    has_many :users, class_name: 'ESP::User'

    # The collection of reports that belong to the organization.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Report>]
    has_many :reports, class_name: 'ESP::Report'

    # The collection of external_accounts that belong to the organization.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::ExternalAccount>]
    has_many :external_accounts, class_name: 'ESP::ExternalAccount'

    # The collection of organizations that belong to the organization.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::CustomSignature>]
    has_many :custom_signatures, class_name: 'ESP::CustomSignature'

    # Not Implemented. You cannot create an Organization.
    #
    # @private
    def create
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy an Organization.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # @!method self.where(clauses = {})
    #   Return a paginated list filtered by search parameters.
    #
    #   *call-seq* -> +super.where(clauses = {})+
    #
    #   @param clauses [Hash] A hash of attributes with appended predicates to search, sort and include.
    #     ===== Valid Clauses
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#organization-attributes] for valid arguments
    #   @return [ActiveResource::PaginatedCollection<ESP::Organization>]

    # @!method self.find(id)
    #   Find an Organization by id
    #
    #   *call-seq* -> +super.find(id, options = {})+
    #
    #   @overload find(id)
    #   @overload find(id, options = {})
    #     @param options [Hash] Optional hash of options.
    #       ===== Valid Options
    #
    #       +include+ | The list of associated objects to return on the initial request.
    #
    #       ===== Valid Includable Associations
    #
    #       See {API documentation}[http://api-docs.evident.io?ruby#organization-attributes] for valid arguments
    #   @param id [Integer, Numeric, #to_i] Required ID of the organization to retrieve.
    #   @return [ESP::Organization]

    # @!method self.all
    #   Return a paginated list.
    #
    #   @return [ActiveResource::PaginatedCollection<ESP::Organization>]

    # @!method self.create
    # Not Implemented. You cannot create an Organization.
    #
    # @return [void]

    # @!method save
    #   Update an Organization.
    #
    #   ===== Valid Attributes
    #
    #   See {API documentation}[http://api-docs.evident.io?ruby#organization-update] for valid arguments
    #
    #   @return [Boolean]
  end
end
