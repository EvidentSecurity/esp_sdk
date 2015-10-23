# class note

module ESP
  class Stat < ESP::Resource
    include ESP::StatTotals

    # a note

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

    # :section: 'total' rollup methods

    # :method: total

    # :method: total_pass

    # :method: total_fail

    # :method: total_warn

    # :method: total_error

    # :method: total_info

    # :method: total_new_1h_pass

    # :method: total_new_1h_fail

    # :method: total_new_1h_warn

    # :method: total_new_1h_error

    # :method: total_new_1h_info

    # :method: total_new_1d_pass

    # :method: total_new_1d_fail

    # :method: total_new_1d_warn

    # :method: total_new_1d_error

    # :method: total_new_1d_info

    # :method: total_new_1w_pass

    # :method: total_new_1w_fail

    # :method: total_new_1w_error

    # :method: total_new_1w_info

    # :method: total_new_1w_warn

    # :method: total_old_fail

    # :method: total_old_pass

    # :method: total_old_warn

    # :method: total_old_error

    # :method: total_old_info

    # :method: total_suppressed

    # :method: total_suppressed_pass

    # :method: total_suppressed_fail

    # :method: total_suppressed_warn

    # :method: total_suppressed_error

    # :method: total_new_1h

    # :method: total_new_1d

    # :method: total_new_1w

    # :method: total_old
  end
end
