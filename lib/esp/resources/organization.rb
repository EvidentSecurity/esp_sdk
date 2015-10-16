module ESP
  class Organization < ESP::Resource
    ##
    # The collection of teams that belong to the organization.
    has_many :teams, class_name: 'ESP::Team'

    ##
    # The collection of sub_organizations that belong to the organization.
    has_many :sub_organizations, class_name: 'ESP::SubOrganization'

    ##
    # The collection of users that belong to the organization.
    has_many :users, class_name: 'ESP::User'

    ##
    # The collection of reports that belong to the organization.
    has_many :reports, class_name: 'ESP::Report'

    ##
    # The collection of external_accounts that belong to the organization.
    has_many :external_accounts, class_name: 'ESP::ExternalAccount'

    ##
    # The collection of organizations that belong to the organization.
    has_many :custom_signatures, class_name: 'ESP::CustomSignature'

    # Not Implemented. You cannot create an Organization.
    def create # :nodoc:
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy an Organization.
    def destroy
      fail ESP::NotImplementedError
    end

    # :singleton-method: find
    # Find an Organization by id
    # :call-seq:
    #  find(id)

    # :singleton-method: create
    # Not Implemented. You cannot create an Organization.

    # :method: save
    # Update an Organization.
    #
    # ==== Valid Attributes
    #
    # * +name+
    #
    # :call-seq:
    #   save
    #   new(attributes={}).save
  end
end
