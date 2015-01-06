require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class CustomSignaturesTest < ActiveSupport::TestCase
  context 'CustomSignatures' do
    setup do
      # Stub the token setup for our configuration object
      EspSdk::Configure.any_instance.expects(:token_setup).returns(nil).at_least_once
      @config = EspSdk::Configure.new(email: 'test@evident.io')
      @custom_signatures = EspSdk::EndPoints::CustomSignatures.new(@config)
    end

    context '#run' do
      should 'call validate_run_params and submit' do
        params = { id: 1, regiond: [:us_east_1], external_account_id: 1 }
        valid_params = @custom_signatures.send(:valid_run_params)
        @custom_signatures.expects(:validate_run_params).with(valid_params, params.keys)
        run_url = @custom_signatures.send(:run_url)
        @custom_signatures.expects(:submit).with(run_url, :post, params)
        @custom_signatures.run(params)
      end
    end

    context '#run_raw' do
      should 'call validate_run_params and submit' do
        params = { signature: 'test', regiond: [:us_east_1], external_account_id: 1 }
        valid_params = @custom_signatures.send(:valid_run_raw_params)
        @custom_signatures.expects(:validate_run_params).with(valid_params, params.keys)
        run_url = @custom_signatures.send(:run_url)
        @custom_signatures.expects(:submit).with(run_url, :post, params)
        @custom_signatures.run_raw(params)
      end
    end

    context '#run_url' do
      should 'have the correct run_url for development environment' do
        EspSdk.instance_variable_set(:@env, :development)
        assert_equal 'http://0.0.0.0:3000/api/v1/custom_signatures/run', @custom_signatures.send(:run_url)
      end

      should 'have the correct run_url for the release environment' do
        EspSdk.instance_variable_set(:@env, :release)
        assert_equal 'https://api-rel.evident.io/api/v1/custom_signatures/run', @custom_signatures.send(:run_url)
      end

      should 'have the correct run_url for the production environment' do
        EspSdk.instance_variable_set(:@env, :production)
        assert_equal 'https://api.evident.io/api/v1/custom_signatures/run', @custom_signatures.send(:run_url)
      end
    end

    context '#valid_run_params' do
      should 'have the correct keys' do
        valid_params = @custom_signatures.send(:valid_run_params)

        [:id, :regions, :external_account_id].each do |key|
          assert_includes valid_params, key
        end
      end
    end

    context '#valid_run_raw_params' do
      should 'have the correct keys' do
        valid_params = @custom_signatures.send(:valid_run_raw_params)
        [:signature, :regions, :external_account_id].each do |key|
          assert_includes valid_params, key
        end
      end
    end

    context '#validate_run_params' do
      setup { @valid_params = @custom_signatures.send(:valid_run_params) }
      should 'raise an error for a missing param' do
        e = assert_raises EspSdk::MissingAttribute do
          @custom_signatures.send(:validate_run_params, @valid_params, { id: 1, regions: [:us_east_1] })
        end

        assert_equal 'Missing required attribute external_account_id', e.message
      end

      should 'raise an error for an unknown attribute' do
        e = assert_raises EspSdk::UnknownAttribute do
          @custom_signatures.send(:validate_run_params, @valid_params, { id: 1, regions: [:us_east_1],
                                                                      external_account_id: 1, bad_param: 1}.keys)
        end

        assert_equal 'Unknown attribute bad_param', e.message
      end
    end
  end
end
