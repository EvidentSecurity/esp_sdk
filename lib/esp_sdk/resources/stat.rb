module ESP
  class Stat < ESP::Resource
    def self.find(*)
      fail ESP::NotImplemented, 'Regular ARELlike methods are disabled.  Use either the .for_report or .latest_for_teams method.'
    end

    def save
      fail ESP::NotImplemented
    end

    def destroy
      fail ESP::NotImplemented
    end

    def self.for_report(report_id)
      raise ArgumentError, "expected a report_id" unless report_id.present?
      # call find_one directly since find is overriden/not implemented
      find_one(from: "#{prefix}reports/#{report_id}/stats.json")
    end

    def self.latest_for_teams
      # call find_every directly since find is overriden/not implemented
      find_every(from: :latest_for_teams)
    end
  end
end
