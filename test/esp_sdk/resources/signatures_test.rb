require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class SignaturesTest < ActiveSupport::TestCase
  context 'Signatures' do
    setup do
      # Stub the token setup for our configuration object
      ESP::Configure.any_instance.expects(:token_setup).returns(nil).at_least_once
      @config = ESP::Configure.new(email: 'test@evident.io')
      @signatures = ESP::Signatures.new(@config)
    end

    context '#run' do
      should 'call validate_run_params and submit' do
        params = { signature_name: 'test', regions: [:us_east_1], external_account_id: 1 }
        run_url = @signatures.send(:run_url)
        @signatures.expects(:validate_run_params).with(params)
        @signatures.expects(:submit).with(run_url, :post, params)
        @signatures.run(params)
      end
    end

    context '#names' do
      should 'call submit' do
        name_url = @signatures.send(:name_url)
        @signatures.expects(:submit).with(name_url, :get)
        @signatures.names
      end
    end

    context '#run_url' do
      should 'have the correct run_url for development environment' do
        ESP.instance_variable_set(:@env, :development)
        assert_equal 'http://0.0.0.0:3000/api/v1/signatures/run', @signatures.send(:run_url)
      end

      should 'have the correct run_url for the release environment' do
        ESP.instance_variable_set(:@env, :release)
        assert_equal 'https://api-rel.evident.io/api/v1/signatures/run', @signatures.send(:run_url)
      end

      should 'have the correct run_url for the production environment' do
        ESP.instance_variable_set(:@env, :production)
        assert_equal 'https://api.evident.io/api/v1/signatures/run', @signatures.send(:run_url)
      end
    end

    context '#name_url' do
      should 'have the correct run_url for development environment' do
        ESP.instance_variable_set(:@env, :development)
        assert_equal 'http://0.0.0.0:3000/api/v1/signatures/signature_names', @signatures.send(:name_url)
      end

      should 'have the correct run_url for the release environment' do
        ESP.instance_variable_set(:@env, :release)
        assert_equal 'https://api-rel.evident.io/api/v1/signatures/signature_names', @signatures.send(:name_url)
      end

      should 'have the correct run_url for the production environment' do
        ESP.instance_variable_set(:@env, :production)
        assert_equal 'https://api.evident.io/api/v1/signatures/signature_names', @signatures.send(:name_url)
      end
    end

    context '#validate_run_params' do
      should 'raise an error for a missing param' do
        e = assert_raises ESP::MissingAttribute do
          @signatures.send(:validate_run_params, signature_name: 'test', regions: [:us_east_1])
        end

        assert_equal 'Missing required attribute external_account_id', e.message
      end

      should 'raise an error for an unknown attribute' do
        e = assert_raises ESP::UnknownAttribute do
          @signatures.send(:validate_run_params,
                           signature_name: 'test', regions: [:us_east_1],
                           external_account_id: 1, bad_param: 1)
        end

        assert_equal 'Unknown attribute bad_param', e.message
      end
    end
  end
end
