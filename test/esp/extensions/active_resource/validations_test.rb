require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module ActiveResource
  class ValidationsTest < ActiveSupport::TestCase
    context ActiveResource::Validations do
      context "with ESP::Team" do
        context '#load_remote_errors' do
          should 'should parse an active record response and put error messages in the errors object' do
            stub_request(:post, /teams.json*/).to_return(status: 422, body: json(:error, :active_record))

            team = ESP::Team.create

            assert_contains team.errors.full_messages, "Name can't be blank"
            assert_contains team.errors.full_messages, "Name is invalid"
            assert_contains team.errors.full_messages, "Description can't be blank"
          end

          should 'should parse a non active record response and put error messages in the errors object' do
            stub_request(:post, /teams.json*/).to_return(status: 422, body: json(:error))

            team = ESP::Team.create

            assert_contains team.errors.full_messages, "Access Denied"
          end
        end
      end
    end
  end
end
