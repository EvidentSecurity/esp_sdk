ENV['ESP_ENV'] = 'test'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'esp_sdk'
require 'minitest/autorun'
require 'minitest/reporters'
require 'shoulda'
require 'mocha'
require 'fakeweb'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
