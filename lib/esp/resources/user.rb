module ESP
  class User < ESP::Resource
    belongs_to :organization, class_name: 'ESP::Organization'
    has_many :contact_requests, class_name: 'ESP::ContactRequest'

    def sub_organizations
      SubOrganization.where(sub_organizations_filter)
    end

    def teams
      Team.where(teams_filter)
    end

    def save
      fail ESP::NotImplemented
    end

    def destroy
      fail ESP::NotImplemented
    end

    private

    def sub_organizations_filter
      { q: { id_in: links.sub_organizations.linkage.collect(&:id) } }
    end

    def teams_filter
      { q: { id_in: links.teams.linkage.collect(&:id) } }
    end
  end
end
