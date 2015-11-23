module ESP
  class User < ESP::Resource
    ##
    # The organization this user belongs to.
    belongs_to :organization, class_name: 'ESP::Organization'

    # Not Implemented. You cannot create or update a User.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a User.
    def destroy
      fail ESP::NotImplementedError
    end

    ##
    # The collection of sub organizations that belong to the user.
    def sub_organizations
      return attributes['sub_organizations'] if attributes['sub_organizations'].present?
      SubOrganization.where(id_in: sub_organization_ids)
    end

    ##
    # The collection of teams that belong to the user.
    def teams
      return attributes['teams'] if attributes['teams'].present?
      Team.where(id_in: team_ids)
    end

    # :singleton-method: where
    # Return a paginated User list filtered by search parameters
    #
    # ==== Parameters
    #
    # +clauses+ | Hash of attributes with appended predicates to search, sort and include.
    #
    # ===== Valid Equality Searchable Attributes
    #
    # +id+
    #
    # +email+
    #
    # ===== Valid Matching Searchable Attributes
    #
    # +email+
    #
    # ===== Valid Sortable Attributes
    #
    # +updated_at+
    #
    # +created_at+
    #
    # ===== Valid Searchable Relationships
    #
    # +organization+ | See Organization `where` for searchable attributes.
    #
    # +sub_organizations+ | See SubOrganization `where` for searchable attributes.
    #
    # +teams+ | See Team `where` for searchable attributes.
    #
    # ===== Valid Includable Associations
    #
    # +organization+
    #
    # +sub_organizations+
    #
    # +teams+
    #
    # :call-seq:
    #  where(clauses = {})

    ##
    # :singleton-method: find
    # Find a User by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the user to retrieve
    #
    # +options+ | Optional | A hash of options
    #
    # ===== Valid Options
    #
    # +include+ | The list of associated objects to return on the initial request.
    #
    # ===== Valid Includable Associations
    #
    # +organization+
    #
    # +sub_organizations+
    #
    # +teams+
    #
    # :call-seq:
    #  find(id, options = {})

    # :singleton-method: all
    # Return a paginated User list

    # :singleton-method: create
    # Not Implemented. You cannot create a User.
  end
end
