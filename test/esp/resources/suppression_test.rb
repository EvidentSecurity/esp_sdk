require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class SuppressionTest < ActiveSupport::TestCase
    context ESP::Suppression do
      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Suppression.create(reason: 'test')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          s = build(:suppression)
          assert_raises ESP::NotImplementedError do
            s.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          s = build(:suppression)
          assert_raises ESP::NotImplementedError do
            s.destroy
          end
        end
      end

      context '#organization' do
        should 'call the api' do
          s = build(:suppression, organization_id: 1)
          stub_org = stub_request(:get, %r{organizations/#{s.organization_id}.json*}).to_return(body: json(:organization))

          s.organization

          assert_requested(stub_org)
        end
      end

      context '#created_by' do
        should 'call the api' do
          s = build(:suppression, created_by_id: 1)
          stub_user = stub_request(:get, %r{users/#{s.created_by_id}.json*}).to_return(body: json(:user))

          s.created_by

          assert_requested(stub_user)
        end
      end

      context '#regions' do
        should 'call the api for the report and the passed in params' do
          suppression = build(:suppression, region_ids: [1, 2])
          stub_request(:put, /regions.json*/).to_return(body: json_list(:region, 2))

          suppression.regions

          assert_requested(:put, /regions.json*/) do |req|
            body = JSON.parse(req.body)
            assert_equal [1, 2], body["filter"]["id_in"]
          end
        end

        should 'not call the api if it was returned in an include' do
          stub_request(:get, %r{suppressions/1.json*}).to_return(body: json(:suppression, :with_include))
          suppression = ESP::Suppression.find(1)
          stub_request(:put, /regions.json*/)

          assert_not_nil suppression.attributes['regions']

          suppression.regions

          assert_not_requested(:put, /regions.json*/)
        end
      end

      context '#external_accounts' do
        should 'call the api for the report and the passed in params' do
          suppression = build(:suppression, external_account_ids: [1, 2])
          stub_request(:put, /external_accounts.json*/).to_return(body: json_list(:external_account, 2))

          suppression.external_accounts

          assert_requested(:put, /external_accounts.json*/) do |req|
            body = JSON.parse(req.body)
            assert_equal [1, 2], body["filter"]["id_in"]
          end
        end

        should 'not call the api if it was returned in an include' do
          stub_request(:get, %r{suppressions/1.json*}).to_return(body: json(:suppression, :with_include))
          suppression = ESP::Suppression.find(1)
          stub_request(:put, /external_accounts.json*/)

          assert_not_nil suppression.attributes['external_accounts']

          suppression.external_accounts

          assert_not_requested(:put, /external_accounts.json*/)
        end
      end

      context '#signatures' do
        should 'call the api for the report and the passed in params' do
          suppression = build(:suppression, signature_ids: [1, 2])
          stub_request(:put, /signatures.json*/).to_return(body: json_list(:signature, 2))

          suppression.signatures

          assert_requested(:put, /signatures.json*/) do |req|
            body = JSON.parse(req.body)
            assert_equal [1, 2], body["filter"]["id_in"]
          end
        end

        should 'not call the api if it was returned in an include' do
          stub_request(:get, %r{suppressions/1.json*}).to_return(body: json(:suppression, :with_include))
          suppression = ESP::Suppression.find(1)
          stub_request(:put, /signatures.json*/)

          assert_not_nil suppression.attributes['signatures']

          suppression.signatures

          assert_not_requested(:put, /signatures.json*/)
        end
      end

      context '#custom_signatures' do
        should 'call the api for the report and the passed in params' do
          suppression = build(:suppression, custom_signature_ids: [1, 2])
          stub_request(:put, /custom_signatures.json*/).to_return(body: json_list(:custom_signature, 2))

          suppression.custom_signatures

          assert_requested(:put, /custom_signatures.json*/) do |req|
            body = JSON.parse(req.body)
            assert_equal [1, 2], body["filter"]["id_in"]
          end
        end

        should 'not call the api if it was returned in an include' do
          stub_request(:get, %r{suppressions/1.json*}).to_return(body: json(:suppression, :with_include))
          suppression = ESP::Suppression.find(1)
          stub_request(:put, /custom_signatures.json*/)

          assert_not_nil suppression.attributes['custom_signatures']

          suppression.custom_signatures

          assert_not_requested(:put, /custom_signatures.json*/)
        end
      end

      context '#deactivate' do
        should 'call the api and not throw an error if an error is returned' do
          s = build(:suppression)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          s.expects(:patch).raises(error)

          assert_nothing_raised do
            refute_predicate s, :deactivate
          end

          assert_equal JSON.parse(error_response)['errors'].first['title'], s.errors.full_messages.first
        end
      end

      context '#deactivate!' do
        should 'call the api and throw an error if an error is returned' do
          s = build(:suppression)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          s.expects(:patch).raises(error)

          error = assert_raises ActiveResource::ResourceInvalid do
            s.deactivate!
          end
          assert_equal "Failed.  Response code = 400.  Response message = #{JSON.parse(error_response)['errors'].first['title']}.", error.message
        end
      end
    end
  end
end
