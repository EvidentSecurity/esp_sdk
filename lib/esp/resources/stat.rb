module ESP
  class Stat < ESP::Resource
    def self.find(*)
      fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use either the .for_report or .latest_for_teams method.'
    end

    def save
      fail ESP::NotImplementedError
    end

    def destroy
      fail ESP::NotImplementedError
    end

    def self.for_report(report_id = nil)
      fail ArgumentError, "You must supply a report id." unless report_id.present?
      # call find_one directly since find is overriden/not implemented
      find_one(from: "#{prefix}reports/#{report_id}/stats.json")
    end

    def self.latest_for_teams
      # call find_every directly since find is overriden/not implemented
      find_every(from: :latest_for_teams)
    end
  end
end
