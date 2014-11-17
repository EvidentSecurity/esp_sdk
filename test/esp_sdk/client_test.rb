require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ClientTest < ActiveSupport::TestCase
  context 'Client' do
    setup do
      # Stub the token setup for our configuration object
      EspSdk::Configure.any_instance.expects(:token_setup).returns(nil).at_least_once
      @config = EspSdk::Configure.new(email: 'demo@evident.io')
      @config.token = '1234abc'
      @client = EspSdk::Client.new(@config)
    end

    context '#initalize' do
      # Sanity check really.
      should 'set the config on the client' do
        assert @client.config.is_a?(EspSdk::Configure)
        assert_equal 'demo@evident.io', @client.config.email
        assert_equal '1234abc', @client.config.token
      end
    end

    context '#connect' do
      setup { @url = 'https://esp.evident.io/api/v1/test' }
      [:get, :delete].each do |type|
        should "make #{type} request with headers only" do
          # Make sure the correct RestClient method is called and arguments are passed
          RestClient.expects(type).with(@url, @client.send(:headers))
          @client.connect(@url, type)
        end

        should "make #{type} request with headers and payload" do
          payload = { id: 1 }
          # Make sure the correct RestClient method is called and arguments are passed
          RestClient.expects(type).with(@url, @client.send(:headers).merge(params: { @client.send(:payload_key) => payload }))
          @client.connect(@url, type, payload)
        end
      end

      [:post, :patch, :put].each do |type|
        should "raise MissingAttribute exception for an empty payload from request type #{type}" do
          e = assert_raises EspSdk::MissingAttribute do
            @client.connect(@url, type)
          end

          assert_equal 'Missing required attributes', e.message
        end

        should "make #{type} request with headers and payload" do
          payload = { id: 1 }
          # Make sure the correct RestClient method is called and arguments are passed
          RestClient.expects(type).with(@url, { @client.send(:payload_key) => payload }, @client.send(:headers))
          @client.connect(@url, type, payload)
        end
      end
    end

    context '#headers' do
      should 'have the correct keys and values' do
        headers = @client.send(:headers)
        # Assert the correct keys are present
        assert headers.is_a?(Hash)
        assert headers.key?('Authorization')
        assert headers.key?('Authorization-Email')
        assert headers.key?('Content-Type')
        assert headers.key?('Accept')

        # Assert the correct values are present
        assert_equal @config.token, headers['Authorization']
        assert_equal @config.email, headers['Authorization-Email']
        assert_equal 'application/json', headers['Content-Type']
        assert_equal 'application/json', headers['Accept']
      end
    end

    context '#payload_key' do
      should 'create the correct payload key' do
        # Check this through and endpoint class.
        # Should take the class name and turn it into a valid key the api understands
        external_account = EspSdk::EndPoints::ExternalAccounts.new(@config)
        assert_equal 'external_account', external_account.send(:payload_key)
      end
    end

    context '#check_errors' do
      should 'return nil when errors are blank' do
        assert_nil @client.send(:check_errors, {})
      end

      should 'return nil when errors is not a hash' do
        assert_nil @client.send(:check_errors, [1])
      end

      should 'return nil when errors is missing the errors key' do
        assert_nil @client.send(:check_errors, { test: 1 })
      end

      should 'raise TokenExpired exception when a token has expired error is present' do
        e = assert_raises EspSdk::TokenExpired do
          @client.send(:check_errors, { 'errors' => ['Token has expired'] })
        end
        assert_equal 'Token has expired', e.message
      end

      should 'raise TokenExpired exception when a record has not been found' do
        e = assert_raises EspSdk::RecordNotFound do
          @client.send(:check_errors, { 'errors' => ['Record not found'] })
        end
        assert_equal 'Record not found', e.message
      end

      should 'join the return errors into a EspSdk::Exception' do
        e = assert_raises EspSdk::Exception do
          @client.send(:check_errors, { 'errors' => ['ARN is blank', 'External ID is blank'] })
        end
        assert_equal 'ARN is blank. External ID is blank', e.message
      end
    end
  end
end