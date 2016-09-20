module ESP
  class User < ESP::Resource
    # The organization this user belongs to.
    #
    # @return [ESP::Organization]
    belongs_to :organization, class_name: 'ESP::Organization'

    # Not Implemented. You cannot create or update a User.
    #
    # @return [void]
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a User.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # The collection of sub organizations that belong to the user.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::SubOrganization>]
    def sub_organizations
      return attributes['sub_organizations'] if attributes['sub_organizations'].present?
      SubOrganization.where(id_in: sub_organization_ids)
    end

    # The collection of teams that belong to the user.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Team>]
    def teams
      return attributes['teams'] if attributes['teams'].present?
      Team.where(id_in: team_ids)
    end

    # @!method self.where(clauses = {})
    #   Return a paginated User list filtered by search parameters
    #
    #   *call-seq* -> +super.where(clauses = {})+
    #
    #   @param clauses [Hash] A hash of attributes with appended predicates to search, sort and include.
    #     ===== Valid Clauses
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#user-attributes] for valid arguments
    #   @return [ActiveResource::PaginatedCollection<ESP::User>]

    # @!method self.find(id, options = {})
    #   Find a User by id
    #
    #   *call-seq* -> +super.find(id, options = {})+
    #
    #   @param id [Integer, Numeric, #to_i] Required ID of the user to retrieve.
    #   @param options [Hash] Optional hash of options.
    #     ===== Valid Options
    #
    #     +include+ | The list of associated objects to return on the initial request.
    #
    #     ===== Valid Includable Associations
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#user-attributes] for valid arguments
    #   @return [ESP::User]

    # @!method self.all
    #   Return a paginated User list
    #
    #   @return [ActiveResource::PaginatedCollection<ESP::User>]

    # @!method self.create
    #   Not Implemented. You cannot create a User.
    #
    #   @return [void]
  end
end
