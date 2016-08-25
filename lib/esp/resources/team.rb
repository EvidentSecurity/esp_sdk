module ESP
  class Team < ESP::Resource
    # The organization this team belongs to.
    #
    # @return [ESP::Organization]
    belongs_to :organization, class_name: 'ESP::Organization'

    # The sub organization this team belongs to.
    #
    # @return [ESP::SubOrganization]
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'

    # The collection of external_accounts that belong to the team.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::ExternalAccount>]
    has_many :external_accounts, class_name: 'ESP::ExternalAccount'

    # The collection of reports that belong to the team.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Report>]
    has_many :reports, class_name: 'ESP::Report'

    # The collection of custom_signatures that belong to the team.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::CustomSignature>]
    def custom_signatures
      CustomSignature.where(teams_id_eq: id)
    end

    # Enqueue a report to be run for this team.
    # Returns a Report object with a status of 'queued' and an id
    # Periodically check the API
    #   ESP::Report.find(<id>)
    # until status is 'complete'.
    # If not successful, returns a Report object with the errors object populated.
    #
    # @return [ESP::Report]
    def create_report
      Report.create_for_team(id)
    end

    # @!method self.where(clauses = {})
    #   Return a paginated Team list filtered by search parameters
    #
    #   *call-seq* -> +super.where(clauses = {})+
    #
    #   @param clauses [Hash] A hash of attributes with appended predicates to search, sort and include.
    #     ===== Valid Clauses
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#team-attributes] for valid arguments
    #   @return [ActiveResource::PaginatedCollection<ESP::Team>]

    # @!method self.find(id, options = {})
    #   Find a Team by id
    #
    #   *call-seq* -> +super.find(id, options = {})+
    #
    #   @param id [Integer, Numeric, #to_i] Required ID of the team to retrieve.
    #   @param options [Hash] Optional hash of options.
    #     ===== Valid Options
    #
    #     +include+ | The list of associated objects to return on the initial request.
    #
    #     ===== Valid Includable Associations
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#team-attributes] for valid arguments
    #   @return [ESP::Team]

    # @!method self.all
    #   Return a paginated Team list
    #
    #   @return [ActiveResource::PaginatedCollection<ESP::Team>]

    # @!method self.create(attributes = {})
    #   Create a Team.
    #   *call-seq* -> +super.create(attributes={})+
    #
    #   @param attributes [Hash] Required hash of team attributes.
    #     ===== Valid Attributes
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#team-create] for valid arguments
    #   @return [ESP::Team]
    #   @example
    #     team = ESP::Team.create(name: "Team Name", sub_organization_id: 9)

    # @!method save
    #   Create and update a Team.
    #
    #   ===== Valid Attributes when updating
    #
    #   +name+ | Required | The new name of the team
    #
    #   ===== Valid Attributes when creating
    #
    #   See {API documentation}[http://api-docs.evident.io?ruby#team-create] for valid arguments
    #
    #   @return [Boolean]
    #   @example
    #     team = ESP::Team.new(name: "Team Name", sub_organization_id: 9)
    #     team.save

    # @!method destroy
    #   Delete a Team.
    #
    #   @return [self]
  end
end
