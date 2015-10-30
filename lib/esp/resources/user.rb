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
      SubOrganization.find(:all, params: { id: sub_organization_ids })
    end

    ##
    # The collection of teams that belong to the user.
    def teams
      Team.find(:all, params: { id: team_ids })
    end

    ##
    # :singleton-method: find
    # Find a User by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the user to retrieve
    #
    # :call-seq:
    #  find(id)

    # :singleton-method: all
    # Return a paginated User list

    # :singleton-method: create
    # Not Implemented. You cannot create a User.
  end
end
