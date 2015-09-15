module ESP
  autoload :ExternalAccount, File.expand_path(File.dirname(__FILE__) + '/esp/resources/external_account')
  autoload :Report, File.expand_path(File.dirname(__FILE__) + '/esp/resources/report')
  autoload :Organization, File.expand_path(File.dirname(__FILE__) + '/esp/resources/organization')
  autoload :SubOrganization, File.expand_path(File.dirname(__FILE__) + '/esp/resources/sub_organization')
  autoload :Team, File.expand_path(File.dirname(__FILE__) + '/esp/resources/team')
  autoload :ContactRequest, File.expand_path(File.dirname(__FILE__) + '/esp/resources/contact_request')
  autoload :User, File.expand_path(File.dirname(__FILE__) + '/esp/resources/user')
  autoload :Suppression, File.expand_path(File.dirname(__FILE__) + '/esp/resources/suppression')
  autoload :Signature, File.expand_path(File.dirname(__FILE__) + '/esp/resources/signature')
  autoload :CustomSignature, File.expand_path(File.dirname(__FILE__) + '/esp/resources/custom_signature')
  autoload :Stat, File.expand_path(File.dirname(__FILE__) + '/esp/resources/stat')
  autoload :Service, File.expand_path(File.dirname(__FILE__) + '/esp/resources/service')
  autoload :Alert, File.expand_path(File.dirname(__FILE__) + '/esp/resources/alert')
  autoload :RawAlert, File.expand_path(File.dirname(__FILE__) + '/esp/resources/raw_alert')
  autoload :Dashboard, File.expand_path(File.dirname(__FILE__) + '/esp/resources/dashboard')
  autoload :CloudTrailEvent, File.expand_path(File.dirname(__FILE__) + '/esp/resources/cloud_trail_event')
  module Suppressions
    autoload :UniqueIdentifier, File.expand_path(File.dirname(__FILE__) + '/esp/resources/suppressions/unique_identifier')
    autoload :Signature, File.expand_path(File.dirname(__FILE__) + '/esp/resources/suppressions/signature')
    autoload :Region, File.expand_path(File.dirname(__FILE__) + '/esp/resources/suppressions/region')
  end

  SITE = { development: "http://localhost:3000/api/v2".freeze,
           test: "http://localhost:3000/api/v2".freeze,
           production: "http://esp.evident.io/api/v2".freeze }

  # Default environment is production
  def self.env
    @env ||= ActiveSupport::StringInquirer.new(ENV['ESP_ENV'] || ENV['RAILS_ENV'] || 'production')
  end
end
