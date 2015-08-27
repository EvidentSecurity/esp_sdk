module ESP
  class Team < ESP::Resource
    belongs_to :organization, class_name: 'ESP::Organization'
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'
    has_many :external_accounts, class_name: 'ESP::ExternalAccount'
    has_many :reports, class_name: 'ESP::Report'
  end
end
