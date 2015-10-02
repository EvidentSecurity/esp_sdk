require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class ContactRequestTest < ActiveSupport::TestCase
    context ESP::ContactRequest do
      context '#user' do
        should 'call the api' do
          contact_request = build(:contact_request, user_id: 4)
          stubbed_user = stub_request(:get, %r{users/#{contact_request.user_id}.json*}).to_return(body: json(:user))

          contact_request.user

          assert_requested(stubbed_user)
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @contact_request = ESP::ContactRequest.last
          skip "Live DB does not have any contact_requests.  Add a contact_request and run tests again." if @contact_request.blank?
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '#user' do
          should 'return a user' do
            user = @contact_request.user

            assert_equal @contact_request.user_id, user.id
          end
        end

        context '#CRUD' do
          should 'be able to create, update and destroy' do
            contact_request = ESP::ContactRequest.new(@contact_request.attributes)

            assert_predicate contact_request, :new?

            contact_request.save

            refute_predicate contact_request, :new?

            contact_request.title = 'new title'
            contact_request.save

            assert_nothing_raised do
              ESP::ContactRequest.find(contact_request.id)
            end

            contact_request.destroy

            assert_raises ActiveResource::ResourceInvalid do
              ESP::ContactRequest.find(contact_request.id)
            end
          end
        end
      end
    end
  end
end
