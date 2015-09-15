module ESP
  class Report < ESP::Resource
    belongs_to :organization, class_name: 'ESP::Organization'
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'
    belongs_to :team, class_name: 'ESP::Team'

    def alerts(params = {})
      ESP::Alert.for_report(id, params)
    end

    def stat
      Stat.for_report(id)
    end

    def self.create_for_team(team_id)
      raise ArgumentError, "expected a team_id" unless team_id.present?
      response = connection.post "#{prefix}teams/#{team_id}/report.json"
      response.body
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid => error
      new.tap { |report| report.load_remote_errors(error, true) }
    end

    def save
      fail ESP::NotImplemented
    end

    def destroy
      fail ESP::NotImplemented
    end
  end
end
