require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class CustomSignatureTest < ActiveSupport::TestCase
    context ESP::CustomSignature do
      context '#organization' do
        should 'call the api' do
          custom_signature = build(:custom_signature, organization_id: 4)
          stubbed_organization = stub_request(:get, %r{organizations/#{custom_signature.organization_id}.json*}).to_return(body: json(:organization))

          custom_signature.organization

          assert_requested(stubbed_organization)
        end
      end

      context '.run_sanity_test!' do
        should 'call the api and pass params' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          stub_request(:post, %r{custom_signatures/run.json*}).to_return(body: json_list(:alert, 2))

          alerts = ESP::CustomSignature.run!(external_account_id: 3, regions: 'param2', language: custom_signature.language, signature: custom_signature.signature)

          assert_requested(:post, %r{custom_signatures/run.json*}) do |req|
            body = JSON.parse req.body
            assert_equal false, body['data'].key?('id')
            assert_equal ['param2'], body['data']['attributes']['regions']
            assert_equal custom_signature.language, body['data']['attributes']['language']
            assert_equal custom_signature.signature, body['data']['attributes']['signature']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'throw an error if an error is returned' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)
          stub_request(:post, %r{custom_signatures/run.json*}).to_return(body: json_list(:alert, 2))

          error = assert_raises ActiveResource::ResourceInvalid do
            ESP::CustomSignature.run!(external_account_id: 3, regions: 'param2', language: custom_signature.language, signature: custom_signature.signature)
          end
          assert_equal "Failed.  Response code = 400.  Response message = #{JSON.parse(error_response)['errors'].first['title']}.", error.message
        end
      end

      context '.run_sanity_test' do
        should 'call the api and pass params' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          stub_request(:post, %r{custom_signatures/run.json*}).to_return(body: json_list(:alert, 2))

          alerts = ESP::CustomSignature.run(external_account_id: 3, regions: 'param2', language: custom_signature.language, signature: custom_signature.signature)

          assert_requested(:post, %r{custom_signatures/run.json*}) do |req|
            body = JSON.parse req.body
            assert_equal false, body['data'].key?('id')
            assert_equal ['param2'], body['data']['attributes']['regions']
            assert_equal custom_signature.language, body['data']['attributes']['language']
            assert_equal custom_signature.signature, body['data']['attributes']['signature']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'not throw an error if an error is returned' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)
          stub_request(:post, %r{custom_signatures/run.json*}).to_return(body: json_list(:alert, 2))

          assert_nothing_raised do
            result = ESP::CustomSignature.run(external_account_id: 3, regions: 'param2', language: custom_signature.language, signature: custom_signature.signature)
            assert_equal JSON.parse(error_response)['errors'].first['title'], result.errors.full_messages.first
          end
        end
      end

      context '#run!' do
        should 'call the api and pass params' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          stub_request(:post, %r{custom_signatures/#{custom_signature.id}/run.json*}).to_return(body: json_list(:alert, 2))

          alerts = custom_signature.run!(regions: 'param2')

          assert_requested(:post, %r{custom_signatures/#{custom_signature.id}/run.json*}) do |req|
            body = JSON.parse req.body
            assert_equal custom_signature.id, body['data']['id']
            assert_equal ['param2'], body['data']['attributes']['regions']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'throw an error if an error is returned' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)
          stub_request(:post, %r{custom_signatures/#{custom_signature.id}/run.json*}).to_return(body: json_list(:alert, 2))

          error = assert_raises ActiveResource::ResourceInvalid do
            custom_signature.run!(regions: 'param2')
          end
          assert_equal "Failed.  Response code = 400.  Response message = #{JSON.parse(error_response)['errors'].first['title']}.", error.message
        end
      end

      context '#run' do
        should 'call the api and pass params' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          stub_request(:post, %r{custom_signatures/#{custom_signature.id}/run.json*}).to_return(body: json_list(:alert, 2))

          alerts = custom_signature.run(regions: 'param2')

          assert_requested(:post, %r{custom_signatures/#{custom_signature.id}/run.json*}) do |req|
            body = JSON.parse req.body
            assert_equal custom_signature.id, body['data']['id']
            assert_equal ['param2'], body['data']['attributes']['regions']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'not throw an error if an error is returned' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)
          stub_request(:post, %r{custom_signatures/#{custom_signature.id}/run.json*}).to_return(body: json_list(:alert, 2))

          assert_nothing_raised do
            custom_signature.run(regions: 'param2')
            assert_equal JSON.parse(error_response)['errors'].first['title'], custom_signature.errors.full_messages.first
          end
        end
      end

      context '#suppress' do
        should 'call the api' do
          stub_request(:post, %r{suppressions/signatures.json*}).to_return(body: json(:suppression_signature))
          custom_signature = build(:custom_signature)

          suppression = custom_signature.suppress(regions: ['us_east_1'], external_account_ids: [5], reason: 'because')

          assert_requested(:post, %r{suppressions/signatures.json*}) do |req|
            body = JSON.parse(req.body)
            assert_equal 'because', body['data']['attributes']['reason']
            assert_equal [custom_signature.id], body['data']['attributes']['custom_signature_ids']
            assert_equal ['us_east_1'], body['data']['attributes']['regions']
            assert_equal [5], body['data']['attributes']['external_account_ids']
          end
          assert_equal ESP::Suppression::Signature, suppression.class
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @custom_signature = ESP::CustomSignature.last
          skip "Live DB does not have any custom_signatures.  Add a custom_signature and run tests again." if @custom_signature.blank?
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '#organization' do
          should 'return an organization' do
            organization = @custom_signature.organization

            assert_equal @custom_signature.organization_id, organization.id
            assert_equal ESP::Organization, organization.class
          end
        end

        context '.run' do
          should 'return alerts' do
            external_account_id = ESP::ExternalAccount.last.id
            alerts = ESP::CustomSignature.run(external_account_id: external_account_id, regions: 'us_east_1', language: @custom_signature.language, signature: @custom_signature.signature)

            assert_equal ESP::Alert, alerts.resource_class
          end

          should 'return errors' do
            signature = ESP::CustomSignature.run(external_account_id: 999_999_999_999, regions: 'us_east_1', language: @custom_signature.language, signature: @custom_signature.signature)

            assert_equal "Couldn't find ExternalAccount", signature.errors.full_messages.first
          end
        end

        context '#run' do
          should 'return alerts' do
            external_account_id = ESP::ExternalAccount.last.id
            alerts = @custom_signature.run(external_account_id: external_account_id, regions: ['us_east_1'])

            assert_equal ESP::Alert, alerts.resource_class
          end

          should 'return errors' do
            @custom_signature.run(external_account_id: 999_999_999_999)

            assert_equal "Couldn't find ExternalAccount", @custom_signature.errors.full_messages.first
          end
        end

        context '.where' do
          should 'return custom_signature objects' do
            custom_signatures = ESP::CustomSignature.where(id_eq: @custom_signature.id)

            assert_equal ESP::CustomSignature, custom_signatures.resource_class
          end
        end

        context '#CRUD' do
          should 'be able to create, update and destroy' do
            custom_signature = ESP::CustomSignature.new(@custom_signature.attributes)

            assert_predicate custom_signature, :new?

            custom_signature.save

            refute_predicate custom_signature, :new?

            custom_signature.identifier = 'new identifier'
            custom_signature.save

            assert_nothing_raised do
              ESP::CustomSignature.find(custom_signature.id)
            end

            custom_signature.destroy

            assert_raises ActiveResource::ResourceNotFound do
              ESP::CustomSignature.find(custom_signature.id)
            end
          end
        end
      end
    end
  end
end
