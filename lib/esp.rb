module ESP
  def self.access_key_id=(access_key_id)
    @access_key_id = access_key_id
    ESP::Resource.hmac_access_id = access_key_id
  end

  def self.access_key_id
    @access_key_id || ENV['ESP_ACCESS_KEY_ID']
  end

  def self.secret_access_key=(secret_access_key)
    @secret_access_key = secret_access_key
    ESP::Resource.hmac_secret_key = secret_access_key
  end

  def self.secret_access_key
    @secret_access_key || ENV['ESP_SECRET_ACCESS_KEY']
  end

  SITE = { development: "http://localhost:3000/api/v2".freeze,
           test: "http://localhost:3000/api/v2".freeze,
           production: "http://esp.evident.io/api/v2".freeze }.freeze

  def self.site=(site)
    @site = site
    ESP::Resource.site = site
  end

  def self.site
    @site || SITE[ESP.env.to_sym]
  end

  def self.configure
    yield self
  end

  # Default environment is production
  def self.env
    @env ||= ActiveSupport::StringInquirer.new(ENV['ESP_ENV'] || ENV['RAILS_ENV'] || 'production')
  end

  autoload :Resource, File.expand_path(File.dirname(__FILE__) + '/esp/resources/resource')
  autoload :ExternalAccount, File.expand_path(File.dirname(__FILE__) + '/esp/resources/external_account')
  autoload :Report, File.expand_path(File.dirname(__FILE__) + '/esp/resources/report')
  autoload :Organization, File.expand_path(File.dirname(__FILE__) + '/esp/resources/organization')
  autoload :SubOrganization, File.expand_path(File.dirname(__FILE__) + '/esp/resources/sub_organization')
  autoload :Team, File.expand_path(File.dirname(__FILE__) + '/esp/resources/team')
  autoload :ContactRequest, File.expand_path(File.dirname(__FILE__) + '/esp/resources/contact_request')
  autoload :User, File.expand_path(File.dirname(__FILE__) + '/esp/resources/user')
  autoload :Signature, File.expand_path(File.dirname(__FILE__) + '/esp/resources/signature')
  autoload :CustomSignature, File.expand_path(File.dirname(__FILE__) + '/esp/resources/custom_signature')
  autoload :Stat, File.expand_path(File.dirname(__FILE__) + '/esp/resources/stat')
  autoload :Service, File.expand_path(File.dirname(__FILE__) + '/esp/resources/service')
  autoload :Alert, File.expand_path(File.dirname(__FILE__) + '/esp/resources/alert')
  autoload :RawAlert, File.expand_path(File.dirname(__FILE__) + '/esp/resources/raw_alert')
  autoload :Dashboard, File.expand_path(File.dirname(__FILE__) + '/esp/resources/dashboard')
  autoload :CloudTrailEvent, File.expand_path(File.dirname(__FILE__) + '/esp/resources/cloud_trail_event')
  autoload :Suppression, File.expand_path(File.dirname(__FILE__) + '/esp/resources/suppression')
  class Suppression
    autoload :UniqueIdentifier, File.expand_path(File.dirname(__FILE__) + '/esp/resources/suppression/unique_identifier')
    autoload :Signature, File.expand_path(File.dirname(__FILE__) + '/esp/resources/suppression/signature')
    autoload :Region, File.expand_path(File.dirname(__FILE__) + '/esp/resources/suppression/region')
  end
end
