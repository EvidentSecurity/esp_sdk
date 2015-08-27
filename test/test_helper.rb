ENV['ESP_ENV'] = 'test'
require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/mini_test'
require 'shoulda'
require 'webmock/minitest'
require 'awesome_print'
require 'rubygems'
require 'active_resource'
require 'esp_sdk'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  self.test_order = :random

  setup do
    # Clear stubs
    WebMock.reset!
  end
end
