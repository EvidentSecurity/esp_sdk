require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ConfigureTest < ActiveSupport::TestCase
  context 'Configure' do
    setup do
      # Stub the setup token method
      EspSdk::Configure.any_instance.expects(:token_setup).returns(nil).at_least_once
      @config = EspSdk::Configure.new({email: 'test@test.com', token: 'token'})
    end

    context '#initialize' do
      should 'set a default version of v1' do
        assert_equal 'v1', @config.version
      end
    end

    context '#uri' do
      should 'return the production URI when the environment is production' do
        EspSdk.expects(:production?).returns(true)
        assert_equal 'https://api.evident.io/api', @config.uri
      end

      should 'return the release URI when the environment is release' do
        EspSdk.expects(:production?).returns(false)
        EspSdk.expects(:release?).returns(true)
        assert_equal 'https://api-rel.evident.io/api', @config.uri
      end

      should 'return the development URI when the environment is not release or production' do
        EspSdk.expects(:production?).returns(false)
        EspSdk.expects(:release?).returns(false)
        assert_equal 'http://0.0.0.0:3000/api', @config.uri
      end
    end

    context '#token_setup' do
      setup { EspSdk::Configure.any_instance.unstub(:token_setup) }

      should 'should set the token and token and expires at' do
        FakeWeb.register_uri(:get, /api\/v1\/token\/new/,
                             :body => { authentication_token: 'token',
                                        token_expires_at: 1.hour.from_now }.to_json)
        @config.send(:token_setup, { password: 'password1234' })
        assert_not_nil @config.token
        assert_not_nil @config.token_expires_at
      end
    end
  end
end
