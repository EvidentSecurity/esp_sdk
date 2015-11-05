module ESP
  class SubOrganization < ESP::Resource
    ##
    # The organization this sub organization belongs to.
    belongs_to :organization, class_name: 'ESP::Organization'

    ##
    # The collection of teams that belong to the sub organization.
    has_many :teams, class_name: 'ESP::Team'

    ##
    # The collection of external_accounts that belong to the sub organization.
    has_many :external_accounts, class_name: 'ESP::ExternalAccount'

    ##
    # The collection of reports that belong to the sub organization.
    has_many :reports, class_name: 'ESP::Report'

    ##
    # :singleton-method: find
    # Find a SubOrganization by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the sub organization to retrieve
    #
    # :call-seq:
    #  find(id)

    # :singleton-method: all
    # Return a paginated SubOrganization list

    # :singleton-method: create
    # Create a SubOrganization.
    # :call-seq:
    #   create(attributes={})
    #
    # ==== Parameters
    #
    # +attributes+ | Required | A hash of run arguments
    #
    # ===== Valid Attributes
    #
    # +name+ | Required | The name of the sub organization
    #
    # ==== Example
    #
    #  sub_organization = ESP::SubOrganization.create(name: "Sub Organization Name")

    # :method: save
    # Create and update a SubOrganization.
    #
    # ==== Parameters
    #
    # +attributes+ | Required | A hash of run arguments
    #
    # ===== Valid Attributes
    #
    # +name+ | Required | The name of the sub organization
    #
    # ==== Example
    #
    #  sub_organization = ESP::SubOrganization.new(name: "Sub Organization Name")
    #  sub_organization.save

    # :method: destroy
    # Delete a SubOrganization.
  end
end
