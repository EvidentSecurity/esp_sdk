module ESP
  class User < ESP::Resource
    belongs_to :organization, class_name: 'ESP::Organization'
    has_many :contact_requests, class_name: 'ESP::ContactRequest'

    def save
      fail ESP::NotImplementedError
    end

    def destroy
      fail ESP::NotImplementedError
    end

    def sub_organizations
      SubOrganization.find(:all, params: { id: sub_organization_ids })
    end

    def teams
      Team.find(:all, params: { id: team_ids })
    end
  end
end
