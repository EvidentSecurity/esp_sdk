require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class SuppressionTest < ActiveSupport::TestCase
    context ESP::Suppression do
      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::User.create(name: 'test')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          u = build(:user)
          assert_raises ESP::NotImplementedError do
            u.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          u = build(:user)
          assert_raises ESP::NotImplementedError do
            u.destroy
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
          suppression = build(:suppression)
          stub_request(:get, /regions.json*/).to_return(body: json_list(:region, 2))

          suppression.regions

          assert_requested(:get, /regions.json*/) do |req|
            assert_equal "filter[suppressions_id_eq]=#{suppression.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#external_accounts' do
        should 'call the api for the report and the passed in params' do
          suppression = build(:suppression)
          stub_request(:get, /external_accounts.json*/).to_return(body: json_list(:external_account, 2))

          suppression.external_accounts

          assert_requested(:get, /external_accounts.json*/) do |req|
            assert_equal "filter[suppressions_id_eq]=#{suppression.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#signatures' do
        should 'call the api for the report and the passed in params' do
          suppression = build(:suppression, signature_ids: [1, 2])
          stub_request(:get, /signatures.json*/).to_return(body: json_list(:signature, 2))

          suppression.signatures

          assert_requested(:get, /signatures.json*/) do |req|
            assert_equal "filter[id_in][0]=#{suppression.signature_ids.first}&filter[id_in][1]=#{suppression.signature_ids.second}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#custom_signatures' do
        should 'call the api for the report and the passed in params' do
          suppression = build(:suppression, custom_signature_ids: [1, 2])
          stub_request(:get, /custom_signatures.json*/).to_return(body: json_list(:custom_signature, 2))

          suppression.custom_signatures

          assert_requested(:get, /custom_signatures.json*/) do |req|
            assert_equal "filter[id_in][0]=#{suppression.custom_signature_ids.first}&filter[id_in][1]=#{suppression.custom_signature_ids.second}", URI.unescape(req.uri.query)
          end
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

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @s = ESP::Suppression.first
          skip "Live DB does not have any suppressions.  Add a suppression and run tests again." if @s.blank?
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '#organization' do
          should 'return an organization' do
            org = @s.organization

            assert_equal @s.organization_id, org.id
          end
        end

        context '#created_by' do
          should 'return a user' do
            u = @s.created_by

            assert_equal @s.created_by_id, u.id
          end
        end

        context '#regions' do
          should 'return regions' do
            r = @s.regions

            assert_equal ESP::Region, r.resource_class unless r == []
          end
        end

        context '#external_accounts' do
          should 'return external_accounts' do
            e = @s.external_accounts

            assert_equal ESP::ExternalAccount, e.resource_class
          end
        end

        context '#signatures' do
          should 'return signatures' do
            s = @s.signatures

            assert_equal ESP::Signature, s.resource_class unless s == []
          end
        end

        context '#custom_signatures' do
          should 'return custom_signatures' do
            cs = @s.custom_signatures

            assert_equal ESP::CustomSignature, cs.resource_class unless cs == []
          end
        end

        context '#deactivate' do
          should 'deactivate the suppression' do
            status = @s.status

            @s.deactivate

            assert_equal 'inactive', @s.status
            assert_contains @s.errors.full_messages.first, 'Access Denied' if status == 'inactive'
          end
        end

        context '#deactivate!' do
          should 'raise an error if already inactive' do
            status = @s.status

            if status == 'inactive'
              assert_raises ActiveResource::ResourceInvalid do
                @s.deactivate!
              end
              assert_equal 'inactive', @s.status
              assert_contains @s.errors.full_messages.first, 'Access Denied' if status == 'inactive'
            end
          end
        end
      end
    end
  end
end
