require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ApiTest < ActiveSupport::TestCase
  context 'Api' do
    context '#initalize' do
      should 'raise a MissingAttribute error for a missing email' do
        e = assert_raises EspSdk::MissingAttribute do
          EspSdk::Api.new({ })
        end
        assert_equal 'Missing required email', e.message

      end
      should 'raise a MissingAttribute error for a missing token and password' do
        e = assert_raises EspSdk::MissingAttribute do
          EspSdk::Api.new(email: 'test@evident.io')
        end
        assert_equal 'Missing required password or token', e.message

      end

      should 'define our endpoint methods and add them to the end_points array' do
        # Stub the token setup for our configuration object
        EspSdk::Configure.any_instance.expects(:token_setup).returns(nil).at_least_once
        api = EspSdk::Api.new(email: 'test@evident.io', password: 'password')
        end_points = (EspSdk::EndPoints.constants - [:Base]).map(&:to_s).map(&:underscore)
        methods = api.singleton_methods.map(&:to_s)

        assert_equal end_points.count, api.end_points.count

        methods.each do |method|
          assert_includes end_points, method
        end
      end
    end
  end
end