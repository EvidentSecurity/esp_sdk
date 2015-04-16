ENV['ESP_ENV'] = 'test'
require 'coveralls'
Coveralls.wear!

require 'esp_sdk'
require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/mini_test'
require 'shoulda'
require 'webmock/minitest'
require 'awesome_print'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  self.test_order = :random

  setup do
    # Clear stubs
    WebMock.reset!
  end
end
