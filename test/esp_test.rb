require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class ESPTest < ActiveSupport::TestCase
  context ESP do
    setup do
      @original_site = ESP.site
      @original_access_key_id = ESP.access_key_id
      @original_secret_access_key = ESP.secret_access_key
    end

    teardown do
      ESP.site = @original_site
      ESP.access_key_id = @original_access_key_id
      ESP.secret_access_key = @original_secret_access_key
    end

    context '.access_key_id' do
      should 'be set manually' do
        ESP.access_key_id = '1234'

        assert_equal '1234', ESP.access_key_id
        assert_equal '1234', ESP::Resource.hmac_access_id
      end

      should 'be set from an environment variable' do
        ESP.access_key_id = nil
        ENV['ESP_ACCESS_KEY_ID'] = '4321'

        assert_equal '4321', ESP.access_key_id
      end
    end

    context '.secret_access_key' do
      should 'be set manually' do
        ESP.secret_access_key = '1234'

        assert_equal '1234', ESP.secret_access_key
        assert_equal '1234', ESP::Resource.hmac_secret_key
      end

      should 'be set from an environment variable' do
        ESP.secret_access_key = nil
        ENV['ESP_SECRET_ACCESS_KEY'] = '4321'

        assert_equal '4321', ESP.secret_access_key
      end
    end

    context '.site' do
      should 'be set manually' do
        ESP.site = 'http://sample.com'

        assert_equal 'http://sample.com', ESP.site
        assert_equal URI.parse('http://sample.com'), ESP::Resource.site
      end
    end

    context '.configure' do
      should 'set site, access_key_id, secret_access_key' do
        ESP.configure do |config|
          config.site = 'abc'
          config.access_key_id = '1234'
          config.secret_access_key = '5678'
        end

        assert_equal 'abc', ESP.site
        assert_equal URI.parse('abc'), ESP::Resource.site
        assert_equal '1234', ESP.access_key_id
        assert_equal '1234', ESP::Resource.hmac_access_id
        assert_equal '5678', ESP.secret_access_key
        assert_equal '5678', ESP::Resource.hmac_secret_key
      end
    end

    context '.env' do
      setup do
        ESP.instance_variable_set(:@env, nil)
      end

      teardown do
        ESP.instance_variable_set(:@env, nil)
        ENV['ESP_ENV'] = 'test'
        ENV['RAILS_ENV'] = 'test'
      end

      should 'return production when ENV is not set' do
        ENV['ESP_ENV'] = nil
        ENV['RAILS_ENV'] = nil
        assert_predicate ESP.env, :production?
      end

      should 'return test when ENV[ESP_ENV] is set to test' do
        ENV['ESP_ENV'] = 'test'
        assert_predicate ESP.env, :test?
      end
    end
  end
end
