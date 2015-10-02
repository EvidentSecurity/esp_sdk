module ESP
  class Report < ESP::Resource
    belongs_to :organization, class_name: 'ESP::Organization'
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'
    belongs_to :team, class_name: 'ESP::Team'

    def save
      fail ESP::NotImplementedError
    end

    def destroy
      fail ESP::NotImplementedError
    end

    def alerts(params = {})
      ESP::Alert.for_report(id, params)
    end

    def stat
      Stat.for_report(id)
    end

    def self.create_for_team!(team_id = nil)
      result = create_for_team(team_id)
      return result if result.errors.blank?
      result.message = result.errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(result)) # rubocop:disable Style/RaiseArgs
    end

    def self.create_for_team(team_id = nil)
      fail ArgumentError, "You must supply a team id." unless team_id.present?
      response = connection.post "#{prefix}teams/#{team_id}/report.json"
      new(format.decode(response.body), true)
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid => error
      new.tap { |report| report.load_remote_errors(error, true) }
    end
  end
end
