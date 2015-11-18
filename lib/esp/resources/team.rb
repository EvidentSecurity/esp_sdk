module ESP
  class Team < ESP::Resource
    ##
    # The organization this team belongs to.
    belongs_to :organization, class_name: 'ESP::Organization'

    ##
    # The sub organization this team belongs to.
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'

    ##
    # The collection of external_accounts that belong to the team.
    has_many :external_accounts, class_name: 'ESP::ExternalAccount'

    ##
    # The collection of reports that belong to the team.
    has_many :reports, class_name: 'ESP::Report'

    # Enqueue a report to be run for this team.
    # Returns a Report object with a status of 'queued' and an id
    # Periodically check the API
    #   ESP::Report.find(<id>)
    # until status is 'complete'.
    # If not successful, returns a Report object with the errors object populated.
    def create_report
      Report.create_for_team(id)
    end

    # :singleton-method: where
    # Return a paginated Team list filtered by search parameters
    #
    # ==== Parameters
    #
    # +clauses+ | Hash of attributes with appended predicates to search and sort by.
    #
    # ==== Valid Equality Searchable Attributes
    #
    # +id+
    #
    # +name+
    #
    # ==== Valid Matching Searchable Attributes
    #
    # +name+
    #
    # ==== Valid Sortable Attributes
    #
    # +updated_at+
    #
    # +created_at+
    #
    # ==== Valid Searchable Relationships
    #
    # +organization+ | See Organization `where` for searchable attributes.
    #
    # +sub_organizations+ | See SubOrganization `where` for searchable attributes.
    #
    # :call-seq:
    #  where(clauses = {})

    ##
    # :singleton-method: find
    # Find a Team by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the team to retrieve
    #
    # :call-seq:
    #  find(id)

    # :singleton-method: all
    # Return a paginated Team list

    # :singleton-method: create
    # Create a Team.
    # :call-seq:
    #   create(attributes={})
    #
    # ==== Parameter
    #
    # +attributes+ | Required | A hash of team attributes
    #
    # ==== Valid Attributes
    #
    # +sub_organization_id+ | Required | The ID of the sub organization to attach this team to
    #
    # +name+ | Required | The name of the team

    # :method: save
    # Create and update a Team.
    #
    # ==== Valid Attributes when updating
    #
    # +name+ | Required | The new name of the team
    #
    # ==== Valid Attributes when creating
    #
    # +sub_organization_id+ | Required | The ID of the sub organization to attach this team to
    #
    # +name+ | Required | The name of the team
    #
    # ==== Example
    #
    #  team = ESP::Team.new(name: "Team Name", sub_organization_id: 9)
    #  team.save

    # :method: destroy
    # Delete a Team.
  end
end
