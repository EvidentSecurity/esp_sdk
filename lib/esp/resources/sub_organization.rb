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

    # :singleton-method: find
    # Find a SubOrganization by id
    # :call-seq:
    #  find(id)

    # :singleton-method: create
    # Create a SubOrganization.
    # :call-seq:
    #   create(attributes={})
    #
    # ==== Valid Attributes
    #
    # * +name+

    # :method: save
    # Create and update a SubOrganization.
    #
    # ==== Valid Attributes
    #
    # * +name+
    #
    # :call-seq:
    #   save
    #   new(attributes={}).save

    # :method: destroy
    # Delete a SubOrganization.
  end
end