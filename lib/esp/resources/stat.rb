module ESP
  class Stat < ESP::Resource
    include ESP::StatTotals

    # The report these stats are for.
    #
    # @return [ESP::Report]
    belongs_to :report, class_name: 'ESP::Report'

    # The stats for each region associated with this stat object.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::StatRegion>]
    has_many :regions, class_name: 'ESP::StatRegion'

    # The stats for each service associated with this stat object.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::StatService>]
    has_many :services, class_name: 'ESP::StatService'

    # The stats for each signature associated with this stat object.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::StatSignature>]
    has_many :signatures, class_name: 'ESP::StatSignature'

    # The stats for each custom signature associated with this stat object.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::StatCustomSignature>]
    has_many :custom_signatures, class_name: 'ESP::StatCustomSignature'

    # Not Implemented. You cannot search for a Stat.
    #
    # @return [void]
    def self.where(attrs)
      # when calling `latest_for_teams.next_page` it will come into here
      if attrs[:from].to_s.include?('latest_for_teams')
        super
      else
        fail ESP::NotImplementedError
      end
    end

    # Not Implemented. You cannot search for a Stat.
    #
    # @return [void]
    def self.find(*)
      fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use either the ESP::Stat.for_report or ESP::Stat.latest_for_teams method.'
    end

    # @!method self.create
    #   Not Implemented. You cannot create a Stat.
    #
    #   @return [void]

    # @!method save
    #   Not Implemented. You cannot create or update a Stat.
    #
    #   @return [void]

    # @!method destroy
    #   Not Implemented. You cannot delete a Stat.
    #
    #   @return [void]

    # Returns all the stats of all the alerts for a report identified by the report_id parameter. Said report contains all statistics for this alert triggered from signatures contained in all regions for the selected hour.
    #
    # ==== Parameters
    #
    # @param report_id [Integer, Numeric] Required ID of the report to retrieve stats for.
    # @param options [Hash] Optional hash of options.
    #   ===== Valid Options
    #
    #   +include+ | The list of associated objects to return on the initial request.
    #
    #   ===== valid Includable Associations
    #
    #   See {API documentation}[http://api-docs.evident.io?ruby#alert-attributes] for valid arguments
    # @return [ActiveResource::PaginatedCollection<ESP::Stat>]
    # @raise [ArgumentError] if no +report_id+ is supplied.
    def self.for_report(report_id = nil, options = {}) # rubocop:disable Style/OptionHash
      fail ArgumentError, "You must supply a report id." unless report_id.present?
      # call find_one directly since find is overriden/not implemented
      find_one(from: "#{prefix}reports/#{report_id}/stats.json", params: options)
    end

    # Returns all the stats for the most recent report of each team accessible by the given API key.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Stat>]
    def self.latest_for_teams
      # call find_every directly since find is overriden/not implemented
      where(from: "#{prefix}stats/latest_for_teams")
    end

    # @!group 'total' rollup methods

    # @!method total

    # @!method total_pass

    # @!method total_fail

    # @!method total_warn

    # @!method total_error

    # @!method total_info

    # @!method total_new_1h_pass

    # @!method total_new_1h_fail

    # @!method total_new_1h_warn

    # @!method total_new_1h_error

    # @!method total_new_1h_info

    # @!method total_new_1d_pass

    # @!method total_new_1d_fail

    # @!method total_new_1d_warn

    # @!method total_new_1d_error

    # @!method total_new_1d_info

    # @!method total_new_1w_pass

    # @!method total_new_1w_fail

    # @!method total_new_1w_error

    # @!method total_new_1w_info

    # @!method total_new_1w_warn

    # @!method total_old_fail

    # @!method total_old_pass

    # @!method total_old_warn

    # @!method total_old_error

    # @!method total_old_info

    # @!method total_suppressed

    # @!method total_suppressed_pass

    # @!method total_suppressed_fail

    # @!method total_suppressed_warn

    # @!method total_suppressed_error

    # @!method total_new_1h

    # @!method total_new_1d

    # @!method total_new_1w

    # @!method total_old
  end
end
