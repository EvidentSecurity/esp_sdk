ENV['ESP_ENV'] = 'test'
# Don't run coveralls when esp web runs sdk tests.
if ENV['CI_BUILD_STAGE'].to_s.casecmp('test_sdk') != 0
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
require 'minitest/reporters'
require 'factory_girl'
require 'mocha/mini_test'
require 'bourne'
require 'shoulda'
require 'webmock/minitest'
require 'rubygems'
require 'active_resource'
require_relative 'json_strategy'
require_relative '../lib/esp_sdk'

FactoryGirl.definition_file_paths = [File.expand_path('factories', File.dirname(__FILE__))]
FactoryGirl.find_definitions
FactoryGirl.register_strategy(:json, JsonStrategy)
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods # so we can use json(:object) instead of FactoryGirl.json(:object)

  self.test_order = :random

  setup do
    # Clear stubs
    WebMock.reset!
  end

  # factory girl helper to form the correct object when getting a collection of objects
  def json_list(*args)
    page_args        = args.last.delete(:page) if args.last.present? && args.last.is_a?(Hash)
    page_args        ||= { number: 1, size: 20 }
    json_array       = args.first == :empty ? [] : super
    data             = json_array.map { |j| JSON.parse(j)['data'] }
    links            = build_links(data, page_args)
    list             = { 'data'  => data.slice(0, page_args[:size]),
                         "links" => links
    }
    list['included'] = JSON.parse(json_array.first)['included'] if json_array.first.present?
    list.to_json
  end

  private

  def build_links(data, page)
    current_page = page[:number]
    last_page    = (data.count.to_f / page[:size]).ceil
    { "self" => "http://localhost:3000/api/v2/not_the_real_url/but_useful_for_testing.json?page%5Bnumber%5D=#{current_page}&page%5Bsize%5D=#{page[:size]}" }.tap do |links|
      links["prev"] = "http://localhost:3000/api/v2/not_the_real_url/but_useful_for_testing.json?page%5Bnumber%5D=#{current_page - 1}&page%5Bsize%5D=#{page[:size]}" unless current_page == 1
      unless current_page == last_page
        links["next"] = "http://localhost:3000/api/v2/not_the_real_url/but_useful_for_testing.json?page%5Bnumber%5D=#{current_page + 1}&page%5Bsize%5D=#{page[:size]}"
        links["last"] = "http://localhost:3000/api/v2/not_the_real_url/but_useful_for_testing.json?page%5Bnumber%5D=#{last_page}&page%5Bsize%5D=#{page[:size]}"
      end
    end
  end
end

module ESP::Integration
  class TestCase < ActiveSupport::TestCase
    setup do
      WebMock.allow_net_connect!
    end

    teardown do
      WebMock.disable_net_connect!
    end
  end
end
