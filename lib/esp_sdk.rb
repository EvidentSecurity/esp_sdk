require 'active_support/all'
require 'active_resource'
require_relative 'esp_sdk/extensions/active_resource/paginated_collection'
require_relative 'esp_sdk/extensions/active_resource/validations'
require_relative 'esp_sdk/extensions/active_resource/formats/json_api_format'
require 'api_auth'
require 'awesome_print'
require_relative 'esp_sdk/version'
require_relative 'esp_sdk/credentials'
require_relative 'esp_sdk/resources/resource'
require_relative 'esp_sdk/repl'
require_relative 'esp_sdk/exceptions'

module ESP
  autoload :ExternalAccount, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/external_account')
  autoload :Report, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/report')
  autoload :Organization, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/organization')
  autoload :SubOrganization, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/sub_organization')
  autoload :Team, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/team')
  autoload :ContactRequest, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/contact_request')
  autoload :User, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/user')
  autoload :Suppression, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/suppression')
  autoload :Signature, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/signature')
  autoload :CustomSignature, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/custom_signature')
  autoload :Stat, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/stat')
  autoload :Service, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/service')
  autoload :Alert, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/alert')
  autoload :RawAlert, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/raw_alert')
  autoload :Dashboard, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/dashboard')
  autoload :CloudTrailEvent, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/cloud_trail_event')
  module Suppressions
    autoload :UniqueIdentifier, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/suppressions/unique_identifier')
    autoload :Signature, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/suppressions/signature')
    autoload :Region, File.expand_path(File.dirname(__FILE__) + '/esp_sdk/resources/suppressions/region')
  end

  # Default environment is production
  def self.env
    @env ||= (ENV['ESP_ENV'] || ENV['RAILS_ENV'] || :production).to_sym
  end

  # Production environment query method
  def self.production?
    env == :production
  end

  # Release environment query method
  def self.release?
    env == :release
  end

  # Development environment query method
  def self.development?
    env == :development
  end

  # Test environment query method
  def self.test?
    env == :test
  end
end


require_relative 'esp_sdk/configure'
require_relative 'esp_sdk/client'
require_relative 'esp_sdk/resources/base'
require_relative 'esp_sdk/api'

