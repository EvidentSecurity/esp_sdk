module ESP
  class Stat < ESP::Resource
    include ESP::StatTotals

    ##
    # The report these stats are for.
    belongs_to :report, class_name: 'ESP::Report'

    ##
    # The stats for each region associated with this stat object.
    has_many :regions, class_name: 'ESP::StatRegion'

    ##
    # The stats for each service associated with this stat object.
    has_many :services, class_name: 'ESP::StatService'

    ##
    # The stats for each signature associated with this stat object.
    has_many :signatures, class_name: 'ESP::StatSignature'

    ##
    # The stats for each custom signature associated with this stat object.
    has_many :custom_signatures, class_name: 'ESP::StatCustomSignature'

    # Not Implemented. You cannot search for a Stat.
    def self.find(*)
      fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use either the ESP::Stat.for_report or ESP::Stat.latest_for_teams method.'
    end

    # :singleton-method: create
    # Not Implemented. You cannot create a Stat.

    # :method: save
    # Not Implemented. You cannot create or update a Stat.

    # :method: destroy
    # Not Implemented. You cannot delete a Stat.

    # Returns all the stats of all the alerts for a report identified by the report_id parameter. Said report contains all statistics for this alert triggered from signatures contained in all regions for the selected hour.
    def self.for_report(report_id = nil)
      fail ArgumentError, "You must supply a report id." unless report_id.present?
      # call find_one directly since find is overriden/not implemented
      find_one(from: "#{prefix}reports/#{report_id}/stats.json")
    end

    # Returns all the stats for the most recent report of each team accessible by the given API key.
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
