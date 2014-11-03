require 'active_support/all'
require_relative 'esp_sdk/version'
require_relative 'esp_sdk/configure'
require_relative 'esp_sdk/client'
require_relative 'esp_sdk/end_points/base'
require_relative 'esp_sdk/end_points/reports'
require_relative 'esp_sdk/end_points/users'
require_relative 'esp_sdk/end_points/external_accounts'
require_relative 'esp_sdk/end_points/custom_signatures'
require_relative 'esp_sdk/end_points/organizations'
require_relative 'esp_sdk/end_points/sub_organizations'
require_relative 'esp_sdk/end_points/teams'
require_relative 'esp_sdk/end_points/signatures'
require_relative 'esp_sdk/end_points/dashboard'
require_relative 'esp_sdk/end_points/contact_requests'
require_relative 'esp_sdk/end_points/services'
require_relative 'esp_sdk/api'
require_relative 'esp_sdk/exceptions'

module EspSdk
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

