module ESP
  class Stat < ESP::Resource
    # Not Implemented. You cannot search for a Stat.
    def self.find(*)
      fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use either the .for_report or .latest_for_teams method.'
    end

    # Not Implemented. You cannot create or update a Stat.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot delete a Stat.
    def destroy
      fail ESP::NotImplementedError
    end

    # Returns the stats for the given report
    def self.for_report(report_id = nil)
      fail ArgumentError, "You must supply a report id." unless report_id.present?
      # call find_one directly since find is overriden/not implemented
      find_one(from: "#{prefix}reports/#{report_id}/stats.json")
    end

    # Returns the most recent report for each of your teams
    def self.latest_for_teams
      # call find_every directly since find is overriden/not implemented
      find_every(from: :latest_for_teams)
    end
  end
end
