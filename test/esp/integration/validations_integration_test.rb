require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class ValidationsTest < ESP::Integration::TestCase
    context ActiveResource::Validations do
      context 'live calls' do
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
