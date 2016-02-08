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
    # See {API documentation}[http://api-docs.evident.io?ruby#report-create] for valid arguments
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
    # See {API documentation}[http://api-docs.evident.io?ruby#alert-attributes] for valid arguments
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

    # :singleton-method: where
    # Return a paginated Report list filtered by search parameters
    #
    # ==== Parameters
    #
    # +clauses+ | Hash of attributes with appended predicates to search, sort and include.
    #
    # ===== Valid Clauses
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#report-attributes] for valid arguments
    #
    # :call-seq:
    #  where(clauses = {})

    ##
    # :singleton-method: find
    # Find a Report by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the report to retrieve
    #
    # +options+ | Optional | A hash of options
    #
    # ===== Valid Options
    #
    # +include+ | The list of associated objects to return on the initial request.
    #
    # ===== Valid Includable Associations
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#report-attributes] for valid arguments
    #
    # :call-seq:
    #  find(id, options = {})

    # :singleton-method: all
    # Return a paginated Report list
  end
end
