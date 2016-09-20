module ESP
  class Report < ESP::Resource
    module Export
      autoload :Integration, File.expand_path(File.dirname(__FILE__) + '/reports/export/integration')
    end

    # The organization the report belongs to.
    #
    # @return [ESP::Organization]
    belongs_to :organization, class_name: 'ESP::Organization'

    # The sub_organization the report belongs to.
    #
    # @return [ESP::SubOrganization]
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'

    # The team the report belongs to.
    #
    # @return [ESP::Team]
    belongs_to :team, class_name: 'ESP::Team'

    # The external_account the report belongs to.
    #
    # @return [ESP::ExternalAccount]
    belongs_to :external_account, class_name: 'ESP::ExternalAccount'

    # Not Implemented. You cannot update a Report.
    #
    # @return [void]
    def update
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Report.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # Enqueue a report to be run for the given team.
    # Returns a Report object with a status of 'queued' and an id
    #
    # Periodically check the API
    #   ESP::Report.find(<id>)
    # until status is 'complete'.
    #
    # If not successful, returns a Report object with the errors object populated.
    #
    # @param arguments [Hash] See {API documentation}[http://api-docs.evident.io?ruby#report-create] for valid arguments
    # @return [ESP::Report]
    # @raise [ArgumentError] if +team_id: Integer+ is not supplied.
    def self.create(arguments = {})
      fail ArgumentError, "You must supply a team id." unless arguments.with_indifferent_access[:team_id].present?
      super
    rescue ActiveResource::ResourceNotFound => error
      new(arguments).tap { |r| r.load_remote_errors(error, true) }
    end

    # Returns a paginated collection of alerts for the report
    #
    # @overload alerts()
    # @overload alerts(arguments = {})
    # @param arguments [Hash] An optional hash of search criteria to filter the returned collection.
    #   See {API documentation}[http://api-docs.evident.io?ruby#alert-attributes] for valid arguments.
    # @return [ActiveResource::PaginatedCollection<ESP::Alert>]
    # @example
    #   report = ESP::Report.find(345)
    #   alerts = report.alerts(status_eq: 'fail', signature_risk_level_in: ['High'])
    def alerts(arguments = {})
      ESP::Alert.where(arguments.merge(report_id: id))
    end

    # Returns the stats for this report
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Stat>]
    def stat
      ESP::Stat.for_report(id)
    end

    # @!method self.where(clauses = {})
    #   Return a paginated Report list filtered by search parameters
    #
    #   *call-seq* -> +super.where(clauses = {})+
    #
    #   @param clauses [Hash] Hash of attributes with appended predicates to search, sort and include.
    #     See {API documentation}[http://api-docs.evident.io?ruby#report-attributes] for valid arguments
    #   @return [ActiveResource::PaginatedCollection<ESP::Report>]

    # @!method self.find(id)
    #   Find a Report by id
    #
    #   *call-seq* -> +super.find(id, options = {})+
    #
    #   @overload find(id)
    #   @overload find(id, options = {})
    #     @param options [Hash] Optional hash of options.
    #       ===== Valid Options
    #
    #       +include+ | The list of associated objects to return on the initial request.
    #
    #       ===== Valid Includable Associations
    #
    #       See {API documentation}[http://api-docs.evident.io?ruby#report-attributes] for valid arguments
    #
    #   @param id [Integer, Numeric, #to_i] Required ID of the report to retrieve.
    #   @return [ESP::Report]

    # @!method self.all
    #   Return a paginated Report list
    #
    #   @return [ActiveResource::PaginatedCollection<ESP::Report>]
  end
end
