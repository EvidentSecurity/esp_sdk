ENV['ESP_ENV'] = 'test'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'esp_sdk'
require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/mini_test'
require 'shoulda'
require 'mocha'
require 'fakeweb'
require 'awesome_print'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  setup do
    # Clear stubs
    FakeWeb.clean_registry
  end
end
