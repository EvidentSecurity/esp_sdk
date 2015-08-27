require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class ESPTest < ActiveSupport::TestCase
  context 'ESP' do
    context '#env' do
      setup do
        ESP.instance_variable_set(:@env, nil)
        ENV['ESP_ENV'] = nil
      end

      should 'return :production when ENV is not set' do
        ENV.expects(:[]).returns(nil).at_least_once
        assert_equal :production, ESP.env
      end

      should 'return :release when ENV[ESP_ENV] is set to release' do
        ENV.expects(:[]).returns('release').at_least_once
        assert_equal :release, ESP.env
      end
    end

    context '#production?' do
      should 'return true when the environment is :production' do
        ESP.expects(:env).returns(:production)
        assert ESP.production?
      end

      should 'return false when the environment is not :production' do
        ESP.expects(:env).returns(:release)
        refute ESP.production?
      end
    end

    context '#release?' do
      should 'return true when the environment is :release' do
        ESP.expects(:env).returns(:release)
        assert ESP.release?
      end

      should 'return false when the environment is not :release' do
        ESP.expects(:env).returns(:test)
        refute ESP.release?
      end
    end

    context '#development?' do
      should 'return true when the environment is :development' do
        ESP.expects(:env).returns(:development)
        assert ESP.development?
      end

      should 'return false when the environment is not :development' do
        ESP.expects(:env).returns(:test)
        refute ESP.development?
      end
    end

    context '#test?' do
      should 'return true when the environment is :test' do
        ESP.expects(:env).returns(:test)
        assert ESP.test?
      end

      should 'return false when the environment is not :test' do
        ESP.expects(:env).returns(:production)
        refute ESP.test?
      end
    end
  end
end
