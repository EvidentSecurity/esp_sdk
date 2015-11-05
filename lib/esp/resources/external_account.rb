module ESP
  class ExternalAccount < ESP::Resource
    ##
    # The organization the external account belongs to.
    belongs_to :organization, class_name: 'ESP::Organization'

    ##
    # The sub_organization the external account belongs to.
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'

    ##
    # The team the external account belongs to.
    belongs_to :team, class_name: 'ESP::Team'

    # Helper to generate an external id.
    # Called automatically when creating an ExternalAccount if +external_id+ is not already set.
    def generate_external_id
      SecureRandom.uuid
    end

    # This instance method is called by the #save method when new? is true.
    def create # :nodoc:
      attributes['external_id'] ||= generate_external_id
      super
    end

    ##
    # :singleton-method: find
    # Find an ExternalAccount by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the external account to retrieve
    #
    # :call-seq:
    #  find(id)

    # :singleton-method: all
    # Return a paginated CustomSignature list

    # :singleton-method: create
    # Create an ExternalAccount.
    # :call-seq:
    #   create(attributes={})
    #
    # ==== Parameter
    #
    # +attributes+ | Required | A hash of external account attributes
    #
    # ===== Valid Attributes
    #
    # +arn+ | Required | Amazon Resource Name for the IAM role
    #
    # +external_id+ | Required | External identifier set on the role.  This will be set by calling #generate_external_id if not already set.
    #
    # +name+ | Not Required |  The name for this external account
    #
    # +sub_organization_id+ | Required | The ID of the sub organization the external account will belong to
    #
    # +team_id+ | Required | The ID of the team the external account will belong to
    #
    # ==== Example
    #
    #  external_account = ESP::ExternalAccount.create(arn: 'arn:from:aws', external_id: 'c40e6af4-a5a0-422a-9a42-3d7d236c3428', sub_organization_id: 4, team_id: 8)

    # :method: save
    # Create or update an ExternalAccount.
    #
    # ===== Valid Attributes
    #
    # +arn+ | Required | Amazon Resource Name for the IAM role
    #
    # +external_id+ | Required | External identifier set on the role.  This will be set by calling #generate_external_id if not already set.
    #
    # +name+ | Not Required |  The name for this external account
    #
    # +sub_organization_id+ | Required | The ID of the sub organization the external account will belong to
    #
    # +team_id+ | Required | The ID of the team the external account will belong to
    #
    # ==== Example
    #
    #  external_account = ESP::ExternalAccount.new(arn: 'arn:from:aws', external_id: 'c40e6af4-a5a0-422a-9a42-3d7d236c3428', sub_organization_id: 4, team_id: 8)
    #  external_account.save

    # :method: destroy
    # Delete a CustomSignature
  end
end
