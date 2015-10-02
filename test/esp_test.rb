require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class ESPTest < ActiveSupport::TestCase
  context 'ESP' do
    context '.env' do
      setup do
        ESP.instance_variable_set(:@env, nil)
      end

      teardown do
        ESP.instance_variable_set(:@env, nil)
        ENV['ESP_ENV'] = 'test'
      end

      should 'return production when ENV is not set' do
        ENV['ESP_ENV'] = nil
        assert_predicate ESP.env, :production?
      end

      should 'return test when ENV[ESP_ENV] is set to test' do
        ENV['ESP_ENV'] = 'test'
        assert_predicate ESP.env, :test?
      end
    end
  end
end
