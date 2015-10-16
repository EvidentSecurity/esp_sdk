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

    # :singleton-method: find
    # Find a Team by id
    # :call-seq:
    #  find(id)

    # :singleton-method: create
    # Create a Team.
    # :call-seq:
    #   create(attributes={})
    #
    # ==== Valid Attributes
    #
    # * +name+
    # * +sub_organization_id+

    # :method: save
    # Create and update a Team.
    #
    # ==== Valid Attributes when updating
    #
    # * +name+
    #
    # ==== Valid Attributes when creating
    #
    # * +name+
    # * +sub_organization_id+
    #
    # :call-seq:
    #   save
    #   new(attributes={}).save

    # :method: destroy
    # Delete a Team.
  end
end
