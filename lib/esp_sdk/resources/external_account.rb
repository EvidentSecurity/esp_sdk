module ESP
  class ExternalAccount < ESP::Resource
    belongs_to :organization, class_name: 'ESP::Organization'
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'
    belongs_to :team, class_name: 'ESP::Team'

    def generate_external_id
      SecureRandom.uuid
    end

    def create
      attributes['external_id'] ||= generate_external_id
      super
    end
  end
end
