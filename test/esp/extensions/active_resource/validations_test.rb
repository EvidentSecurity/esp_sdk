require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module ActiveResource
  class ValidationsTest < ActiveSupport::TestCase
    context ActiveResource::Validations do
      context "with ESP::Team" do
        context '#load_remote_errors' do
          should 'should parse an active record response and put error messages in the errors object' do
            error = ActiveResource::ResourceInvalid.new('') # ResourceInvalid gets caught by the create method.
            error_response = json(:error, :active_record)
            response = mock(body: error_response)
            error.expects(:response).returns(response)
            ActiveResource::Connection.any_instance.expects(:post).raises(error)
            stub_request(:post, /teams.json*/).to_return(body: json_list(:alert, 2))

            team = ESP::Team.create

            assert_contains team.errors.full_messages, "Name can't be blank"
            assert_contains team.errors.full_messages, "Name is invalid"
            assert_contains team.errors.full_messages, "Description can't be blank"
          end

          should 'should parse a non active record response and put error messages in the errors object' do
            error = ActiveResource::ResourceInvalid.new('') # ResourceInvalid gets caught by the create method.
            error_response = json(:error)
            response = mock(body: error_response)
            error.expects(:response).returns(response)
            ActiveResource::Connection.any_instance.expects(:post).raises(error)
            stub_request(:post, /teams.json*/).to_return(body: json_list(:alert, 2))

            team = ESP::Team.create

            assert_contains team.errors.full_messages, "Access Denied"
          end
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context "#load_remote_errors" do
          should 'should parse the response and put error messages in the errors object' do
            team = ESP::Team.create(name: 'bob')

            assert_contains team.errors.full_messages, "Organization can't be blank"
            assert_contains team.errors.full_messages, "Organization can't be blank"
          end
        end
      end
    end
  end
end
