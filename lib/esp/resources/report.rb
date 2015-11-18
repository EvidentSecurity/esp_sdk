module ESP
  class Report < ESP::Resource
    ##
    # The organization the report belongs to.
    belongs_to :organization, class_name: 'ESP::Organization'

    ##
    # The sub_organization the report belongs to.
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'

    ##
    # The team the report belongs to.
    belongs_to :team, class_name: 'ESP::Team'

    # Not Implemented. You cannot create or update a Report.
    def update
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Report.
    def destroy
      fail ESP::NotImplementedError
    end

    # Enqueue a report to be run for the given team.
    # Returns a Report object with a status of 'queued' and an id
    # ==== Attribute
    #
    # +team_id+ | Required | The ID of the team to create a report for
    #
    # Periodically check the API
    #   ESP::Report.find(<id>)
    # until status is 'complete'.
    #
    # If not successful, returns a Report object with the errors object populated.
    def self.create(arguments = {})
      fail ArgumentError, "You must supply a team id." unless arguments.with_indifferent_access[:team_id].present?
      super
    rescue ActiveResource::ResourceNotFound => error
      new(arguments).tap { |r| r.load_remote_errors(error, true) }
    end

    # Returns a paginated collection of alerts for the report
    #
    # ==== Parameters
    #
    # +arguments+ | Not Required | An optional hash of search criteria to filter the returned collection
    #
    # ===== Valid Arguments
    #
    # +region_id+ | Not Required | Return only alerts for this region.
    #
    # +status+ | Not Required | Return only alerts for the give status(es).  Valid values are fail, warn, error, pass, info
    #
    # +first_seen+ | Not Required | Return only alerts that have started within a number of hours of the report. For example, first_seen of 3 will return alerts that started showing up within the last 3 hours of the report.
    #
    # +suppressed+ | Not Required | Return only suppressed alerts
    #
    # +team_id+ | Not Required | Return only alerts for the given team.
    #
    # +external_account_id+ | Not Required | Return only alerts for the given external id.
    #
    # +service_id+ | Not Required | Return only alerts on signatures with the given service.
    #
    # +signature_severity+ | Not Required | Return only alerts for signatures with the given risk_level.  Valid values are Low, Medium, High
    #
    # +signature_name+ | Not Required | Return only alerts for signatures with the given name.
    #
    # +resource+ | Not Required | Return only alerts for the given resource or tag.
    #
    # +signature_identifier+ | Not Required | Return only alerts for signatures with the given identifier.
    #
    # ==== Example
    #
    #   report = ESP::Report.find(345)
    #   alerts = report.alerts(status: 'fail', signature_severity: 'High')
    def alerts(arguments = {})
      ESP::Alert.where(arguments.merge(report_id: id))
    end

    # Returns the stats for this report
    def stat
      ESP::Stat.for_report(id)
    end

    ##
    # :singleton-method: find
    # Find a Report by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the report to retrieve
    #
    # :call-seq:
    #  find(id)

    # :singleton-method: all
    # Return a paginated Report list
  end
end
