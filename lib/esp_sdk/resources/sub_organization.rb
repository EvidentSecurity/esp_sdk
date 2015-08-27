module ESP
  class SubOrganization < ESP::Resource
    belongs_to :organization, class_name: 'ESP::Organization'
    has_many :teams, class_name: 'ESP::Team'
    has_many :external_accounts, class_name: 'ESP::ExternalAccount'
    has_many :reports, class_name: 'ESP::Report'
  end
end
