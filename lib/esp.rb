module ESP
  # Manually set the access_key_id you created from https://esp.evident.io/settings/api_keys.
  #
  # You can optionally set the +ESP_ACCESS_KEY_ID+ environment variable.
  #
  # @param access_key_id [String] Your access key ID.
  # @return [void]
  def self.access_key_id=(access_key_id)
    @access_key_id               = access_key_id
    ESP::Resource.hmac_access_id = access_key_id
  end

  # Reads the +ESP_ACCESS_KEY_ID+ environment variable if {.access_key_id=} was not set manually.
  #
  # Returns nil if no key or environment variable has been set.
  #
  # @return [String, nil]
  def self.access_key_id
    @access_key_id || ENV['ESP_ACCESS_KEY_ID']
  end

  # Manually set the secret_access_key you created from https://esp.evident.io/settings/api_keys.
  #
  # You can optionally set the +ESP_SECRET_ACCESS_KEY+ environment variable.
  #
  # @param secret_access_key [String] Your secret access key.
  # @return [void]
  def self.secret_access_key=(secret_access_key)
    @secret_access_key            = secret_access_key
    ESP::Resource.hmac_secret_key = secret_access_key
  end

  # Reads the +ESP_SECRET_ACCESS_KEY+ environment variable if {.secret_access_key=} was not set manually.
  #
  # Returns nil if no key or environment variable has been set.
  #
  # @return [String, nil]
  def self.secret_access_key
    @secret_access_key || ENV['ESP_SECRET_ACCESS_KEY']
  end

  PATH = '/api/v2'.freeze

  # @private
  HOST = { development: "http://localhost:3000".freeze,
           test:        "http://localhost:3000".freeze,
           production:  "https://api.evident.io".freeze }.freeze

  # Users of the Evident.io marketplace appliance application will need to set the host for their instance.
  #
  # @param host [String] The host for the installed appliance instance.
  # @return [void]
  def self.host=(host)
    @host              = host
    ESP::Resource.site = site
  end

  # The site the SDK will hit.
  #
  # @return [String]
  def self.site
    "#{(@host || HOST[ESP.env.to_sym] || ENV['ESP_HOST'])}#{PATH}"
  end

  # Manually set an http_proxy
  #
  # You can optionally set the +HTTP_PROXY+ environment variable.
  #
  # @param proxy [String] The URI of the http proxy
  # @return [void]
  def self.http_proxy=(proxy)
    @http_proxy         = proxy
    ESP::Resource.proxy = http_proxy
  end

  # Reads the +HTTP_PROXY+ environment variable if {.http_proxy=} was not set manually.
  #
  # Returns nil if no proxy or environment variable has been set.
  #
  # @return [String, nil]
  def self.http_proxy
    @http_proxy || ENV['http_proxy']
  end

  # For use in a Rails initializer to set the {.access_key_id=}, {.secret_access_key=} and {.site}.
  #
  # @yield [self]
  # @return [void]
  # @example
  #
  #   ESP.configure do |config|
  #     config.access_key_id = <your key>
  #     config.secret_access_key = <your secret key>
  #     config.host = <host of your appliance instance>
  #     config.http_proxy = <your proxy URI>
  #   end
  def self.configure
    yield self
  end

  # Default environment is production which will set {.site} to "https://api.evident.io/api/v2".
  #
  # @return [String]
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
  autoload :ScanInterval, File.expand_path(File.dirname(__FILE__) + '/esp/resources/scan_interval')
  autoload :Service, File.expand_path(File.dirname(__FILE__) + '/esp/resources/service')
  autoload :Alert, File.expand_path(File.dirname(__FILE__) + '/esp/resources/alert')
  autoload :RawAlert, File.expand_path(File.dirname(__FILE__) + '/esp/resources/raw_alert')
  autoload :Dashboard, File.expand_path(File.dirname(__FILE__) + '/esp/resources/dashboard')
  autoload :CloudTrailEvent, File.expand_path(File.dirname(__FILE__) + '/esp/resources/cloud_trail_event')
  autoload :Metadata, File.expand_path(File.dirname(__FILE__) + '/esp/resources/metadata')
  autoload :Tag, File.expand_path(File.dirname(__FILE__) + '/esp/resources/tag')
  autoload :Region, File.expand_path(File.dirname(__FILE__) + '/esp/resources/region')
  autoload :Role, File.expand_path(File.dirname(__FILE__) + '/esp/resources/role')
  autoload :Suppression, File.expand_path(File.dirname(__FILE__) + '/esp/resources/suppression')
  autoload :Stat, File.expand_path(File.dirname(__FILE__) + '/esp/resources/stat')
  autoload :StatCustomSignature, File.expand_path(File.dirname(__FILE__) + '/esp/resources/stat_custom_signature')
  autoload :StatSignature, File.expand_path(File.dirname(__FILE__) + '/esp/resources/stat_signature')
  autoload :StatRegion, File.expand_path(File.dirname(__FILE__) + '/esp/resources/stat_region')
  autoload :StatService, File.expand_path(File.dirname(__FILE__) + '/esp/resources/stat_service')
  autoload :ExternalAccountCreator, File.expand_path(File.dirname(__FILE__) + '/../lib/esp/external_account_creator')
  autoload :AWSClients, File.expand_path(File.dirname(__FILE__) + '/../lib/esp/aws_clients')
end
