require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class DashboardTest < ActiveSupport::TestCase
  context 'Dashboard' do
    setup do
      # Stub the token setup for our configuration object
      EspSdk::Configure.any_instance.expects(:token_setup).returns(nil).at_least_once
      @config = EspSdk::Configure.new(email: 'test@evident.io')
      @dashboard = EspSdk::EndPoints::Dashboard.new(@config)
    end

    context '#timewarp' do
      should 'call validate_timewarp_params and submit' do
        params = { time: 1.hour.ago.to_i }
        url    = @dashboard.send(:timewarp_url)
        @dashboard.expects(:validate_timewarp_params).with(params.keys)
        @dashboard.expects(:submit).with(url, :post, params)
        @dashboard.timewarp(params)
      end
    end

    context '#timewarp_url' do
      should 'have the correct run_url for development environment' do
        EspSdk.instance_variable_set(:@env, :development)
        assert_equal 'http://0.0.0.0:3000/api/v1/dashboard/timewarp', @dashboard.send(:timewarp_url)
      end

      should 'have the correct run_url for the release environment' do
        EspSdk.instance_variable_set(:@env, :release)
        assert_equal 'https://api-rel.evident.io/api/v1/dashboard/timewarp', @dashboard.send(:timewarp_url)
      end

      should 'have the correct run_url for the production environment' do
        EspSdk.instance_variable_set(:@env, :production)
        assert_equal 'https://api.evident.io/api/v1/dashboard/timewarp', @dashboard.send(:timewarp_url)
      end
    end

    context '#validate_timewarp_params' do
      should 'raise a MissingAttribute error for missing the time attribute' do
        e = assert_raises EspSdk::MissingAttribute do
          @dashboard.send(:validate_timewarp_params, [])
        end
        assert_equal 'Missing required attribute time', e.message
      end

      should 'raise a UnknownAttribute for an invalid attribute' do
        e = assert_raises EspSdk::UnknownAttribute do
          @dashboard.send(:validate_timewarp_params, [:time, :invalid])
        end
        assert_equal 'Unknown attribute invalid', e.message
      end
    end
  end
end