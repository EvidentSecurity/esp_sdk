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

    # :singleton-method: create
    # Create an ExternalAccount.
    # :call-seq:
    #   create(attributes={})
    #
    # ==== Attributes
    #
    # * +arn+
    # * +external_id+ - Will be set by calling #generate_external_id if not already set.
    # * +name+
    # * +sub_organization_id+
    # * +team_id+

    # :method: save
    # Create or update an ExternalAccount.
    #
    # ==== Attributes
    #
    # * +arn+
    # * +external_id+ - Will be set by calling #generate_external_id if not already set.
    # * +name+
    # * +sub_organization_id+
    # * +team_id+
    #
    # :call-seq:
    #   save
    #   new(name: 'name', arn: 'arn', sub_organization_id: 2, team_id: 3).save
  end
end
