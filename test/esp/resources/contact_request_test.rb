require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class ContactRequestTest < ActiveSupport::TestCase
    context ESP::ContactRequest do
      context '#find' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::ContactRequest.find(4)
          end
        end
      end

      context '.where' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::ContactRequest.where(id_eq: 2)
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          s = ESP::ContactRequest.new
          assert_raises ESP::NotImplementedError do
            s.update
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          s = ESP::ContactRequest.new
          assert_raises ESP::NotImplementedError do
            s.destroy
          end
        end
      end

      context '#create' do
        should 'call the api' do
          stub_request(:post, /contact_requests.json*/).to_return(body: json(:contact_request))

          contact_request = ESP::ContactRequest.create(user_id: 5, request_type: 'feature', title: 'My great feature idea', description: 'This is my idea for a really useful feature...')

          assert_requested(:post, /contact_requests.json*/) do |req|
            body = JSON.parse(req.body)
            assert_equal 5, body['data']['attributes']['user_id']
            assert_equal 'feature', body['data']['attributes']['request_type']
            assert_equal 'My great feature idea', body['data']['attributes']['title']
            assert_equal 'This is my idea for a really useful feature...', body['data']['attributes']['description']
          end
          assert_equal ESP::ContactRequest, contact_request.class
        end
      end
    end
  end
end
