module ESP
  # Manually set the access_key_id you created from https://esp.evident.io/settings/api_keys.
  #
  # You can optionally set the `ESP_ACCESS_KEY_ID` environment variable.
  def self.access_key_id=(access_key_id)
    @access_key_id = access_key_id
    ESP::Resource.hmac_access_id = access_key_id
  end

  # Reads the `ESP_ACCESS_KEY_ID` environment variable if ::access_key_id was not set manually.
  def self.access_key_id
    @access_key_id || ENV['ESP_ACCESS_KEY_ID']
  end

  # Manually set the secret_access_key you created from https://esp.evident.io/settings/api_keys.
  #
  # You can optionally set the `ESP_SECRET_ACCESS_KEY` environment variable.
  def self.secret_access_key=(secret_access_key)
    @secret_access_key = secret_access_key
    ESP::Resource.hmac_secret_key = secret_access_key
  end

  # Reads the `ESP_SECRET_ACCESS_KEY` environment variable if ::secret_access_key was not set manually.
  def self.secret_access_key
    @secret_access_key || ENV['ESP_SECRET_ACCESS_KEY']
  end

  SITE = { development: "http://localhost:3000/api/v2".freeze,
           test: "http://localhost:3000/api/v2".freeze,
           production: "http://esp.evident.io/api/v2".freeze }.freeze # :nodoc:

  # Users of the Evident.io marketplace appliance application will need to set the site/url for their instance.
  #
  # ==== Attribute
  #
  # * +site+ - The url for the installed appliance instance.
  def self.site=(site)
    @site = site
    ESP::Resource.site = site
  end

  # The site the SDK will hit.
  def self.site
    @site || SITE[ESP.env.to_sym]
  end

  # For use in a Rails initializer to set the ::access_key_id, ::secret_access_key and ::site.
  #
  # ==== Example
  #
  #   ESP.configure do |config|
  #     config.access_key_id = <your key>
  #     config.secret_access_key = <your secret key>
  #     config.site = <url to your appliance instance>
  #   end
  def self.configure
    yield self
  end

  # Default environment is production which will set ::site to "http://esp.evident.io/api/v2".
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
