module ESP
  class Organization < ESP::Resource
    has_many :teams, class_name: 'ESP::Team'
    has_many :sub_organizations, class_name: 'ESP::SubOrganization'
    has_many :users, class_name: 'ESP::User'
    has_many :reports, class_name: 'ESP::Report'
    has_many :external_accounts, class_name: 'ESP::ExternalAccount'
    has_many :custom_signatures, class_name: 'ESP::CustomSignature'
  end
end
