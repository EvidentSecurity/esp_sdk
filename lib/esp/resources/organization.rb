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

    # :singleton-method: where
    # Return a paginated Organization list filtered by search parameters
    #
    # ==== Parameters
    #
    # +clauses+ | Hash of attributes with appended predicates to search, sort and include.
    #
    # ===== Valid Clauses
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#organization-attributes] for valid arguments
    #
    # :call-seq:
    #  where(clauses = {})

    ##
    # :singleton-method: find
    # Find a Organization by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the organization to retrieve
    #
    # +options+ | Optional | A hash of options
    #
    # ===== Valid Options
    #
    # +include+ | The list of associated objects to return on the initial request.
    #
    # ===== Valid Includable Associations
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#organization-attributes] for valid arguments
    #
    # :call-seq:
    #  find(id, options = {})

    # :singleton-method: all
    # Return a paginated Organization list

    # :singleton-method: create
    # Not Implemented. You cannot create an Organization.

    # :method: save
    # Update an Organization.
    #
    # ===== Valid Attributes
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#organization-update] for valid arguments
  end
end
