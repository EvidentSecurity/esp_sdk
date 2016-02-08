require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class ESPTest < ActiveSupport::TestCase
  context ESP do
    setup do
      @original_access_key_id = ESP.access_key_id
      @original_secret_access_key = ESP.secret_access_key
    end

    teardown do
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

    context '.http_proxy' do
      should 'be set manually' do
        ESP.http_proxy = 'http://foo.com/blah_blah'

        assert_equal 'http://foo.com/blah_blah', ESP.http_proxy
        assert_equal URI.parse('http://foo.com/blah_blah'), ESP::Resource.proxy
      end

      should 'be set from an environment variable' do
        ESP.http_proxy = nil
        ENV['http_proxy'] = 'http://foo.com/blah_blah'

        assert_equal 'http://foo.com/blah_blah', ESP.http_proxy
      end
    end

    context '.host=' do
      setup do
        ESP.host = nil
      end

      teardown do
        ESP.host = nil
        ENV['ESP_HOST'] = nil
      end

      should 'set ESP::Resource.site' do
        ESP.host = 'http://sample.com'

        assert_equal URI.parse("http://sample.com#{ESP::PATH}"), ESP::Resource.site
      end
    end

    context '.site' do
      setup do
        ESP.host = nil
      end

      teardown do
        ESP.host = nil
        ENV['ESP_HOST'] = nil
      end

      should "return manually set host with path when set" do
        ESP.host = 'http://sample.com'

        assert_equal URI.parse("http://sample.com#{ESP::PATH}"), ESP::Resource.site
      end

      should 'should return the test host with path' do
        assert_equal "#{ESP::HOST[ESP.env.to_sym]}#{ESP::PATH}", ESP.site
      end

      should "return ENV['ESP_HOST'] with path when in appliance env" do
        ENV['ESP_HOST'] = 'https://sample.com'
        ESP.stubs(:env).returns('appliance')
        assert_equal "https://sample.com#{ESP::PATH}", ESP.site
      end
    end

    context '.configure' do
      setup do
        ESP.host = nil
      end

      teardown do
        ESP.host = nil
      end

      should 'set site, access_key_id, secret_access_key, http_proxy' do
        ESP.configure do |config|
          config.host = 'https://sample.com'
          config.access_key_id = '1234'
          config.secret_access_key = '5678'
          config.http_proxy = 'proxy.com'
        end

        assert_equal "https://sample.com#{ESP::PATH}", ESP.site
        assert_equal URI.parse("https://sample.com#{ESP::PATH}"), ESP::Resource.site
        assert_equal '1234', ESP.access_key_id
        assert_equal '1234', ESP::Resource.hmac_access_id
        assert_equal '5678', ESP.secret_access_key
        assert_equal '5678', ESP::Resource.hmac_secret_key
        assert_equal URI.parse("proxy.com"), ESP::Resource.proxy
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
