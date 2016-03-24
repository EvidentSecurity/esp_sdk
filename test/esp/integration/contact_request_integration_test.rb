require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class ContactRequestTest < ESP::Integration::TestCase
    context ESP::ContactRequest do
      context 'live calls' do
        context '#CRUD' do
          should 'be able to create, update and destroy' do
            contact_request = ESP::ContactRequest.new(user_id: 5, request_type: 'feature', title: 'My great feature idea', description: 'This is my idea for a really useful feature...')

            assert_predicate contact_request, :new?

            contact_request.save

            refute_predicate contact_request, :new?
          end
        end
      end
    end
  end
end
