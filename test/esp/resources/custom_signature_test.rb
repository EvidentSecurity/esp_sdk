require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class CustomSignatureTest < ActiveSupport::TestCase
    context ESP::CustomSignature do
      context '#service' do
        should 'call the api' do
          custom_signature = build(:custom_signature, service_id: 4)
          stubbed_service = stub_request(:get, %r{services/#{custom_signature.service_id}.json*}).to_return(body: json(:service))

          custom_signature.service

          assert_requested(stubbed_service)
        end
      end

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
          stub_request(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/run_sanity_test.json*}).to_return(body: json_list(:alert, 2))

          alerts = ESP::CustomSignature.run_sanity_test!(external_account_id: 3, regions: 'param2', language: custom_signature.language, signature: custom_signature.signature)

          assert_requested(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/run_sanity_test.json*}) do |req|
            body = JSON.parse req.body
            assert_equal false, body['data'].key?('id')
            assert_equal ['param2'], body['data']['attributes']['regions']
            assert_equal custom_signature.language, body['data']['attributes']['language']
            assert_equal custom_signature.signature, body['data']['attributes']['signature']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'raise an error if external_account_id is not provided' do
          custom_signature = build(:custom_signature, external_account_id: nil)

          error = assert_raises ArgumentError do
            ESP::CustomSignature.run_sanity_test!(regions: 'param2', language: custom_signature.language, signature: custom_signature.signature)
          end

          assert_equal "You must supply an external_account_id.", error.message
        end

        should 'throw an error if an error is returned' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response)
          error.expects(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)
          stub_request(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/run_sanity_test.json*}).to_return(body: json_list(:alert, 2))

          error = assert_raises ActiveResource::ResourceInvalid do
            ESP::CustomSignature.run_sanity_test!(external_account_id: 3, regions: 'param2', language: custom_signature.language, signature: custom_signature.signature)
          end
          assert_equal "Failed.  Response message = #{JSON.parse(error_response)['errors'].first['title']}.", error.message
        end
      end

      context '.run_sanity_test' do
        should 'call the api and pass params' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          stub_request(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/run_sanity_test.json*}).to_return(body: json_list(:alert, 2))

          alerts = ESP::CustomSignature.run_sanity_test(external_account_id: 3, regions: 'param2', language: custom_signature.language, signature: custom_signature.signature)

          assert_requested(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/run_sanity_test.json*}) do |req|
            body = JSON.parse req.body
            assert_equal false, body['data'].key?('id')
            assert_equal ['param2'], body['data']['attributes']['regions']
            assert_equal custom_signature.language, body['data']['attributes']['language']
            assert_equal custom_signature.signature, body['data']['attributes']['signature']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'raise an error if external_account_id is not provided' do
          custom_signature = build(:custom_signature, external_account_id: nil)

          error = assert_raises ArgumentError do
            ESP::CustomSignature.run_sanity_test(regions: 'param2', language: custom_signature.language, signature: custom_signature.signature)
          end

          assert_equal "You must supply an external_account_id.", error.message
        end

        should 'not throw an error if an error is returned' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response)
          error.expects(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)
          stub_request(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/run_sanity_test.json*}).to_return(body: json_list(:alert, 2))

          assert_nothing_raised do
            result = ESP::CustomSignature.run_sanity_test(external_account_id: 3, regions: 'param2', language: custom_signature.language, signature: custom_signature.signature)
            assert_equal JSON.parse(error_response)['errors'].first['title'], result.errors.full_messages.first
          end
        end
      end

      context '#run!' do
        should 'call the api and pass params' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          stub_request(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/#{custom_signature.id}/run_existing.json*}).to_return(body: json_list(:alert, 2))

          alerts = custom_signature.run!(regions: 'param2')

          assert_requested(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/#{custom_signature.id}/run_existing.json*}) do |req|
            body = JSON.parse req.body
            assert_equal custom_signature.id, body['data']['id']
            assert_equal ['param2'], body['data']['attributes']['regions']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'raise an error if external_account_id is not provided' do
          custom_signature = build(:custom_signature, external_account_id: nil)

          error = assert_raises ArgumentError do
            custom_signature.run!(regions: 'param2')
          end

          assert_equal "You must supply an external_account_id.", error.message
        end

        should 'throw an error if an error is returned' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response)
          error.expects(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)
          stub_request(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/#{custom_signature.id}/run_existing.json*}).to_return(body: json_list(:alert, 2))

          error = assert_raises ActiveResource::ResourceInvalid do
            custom_signature.run!(regions: 'param2')
          end
          assert_equal "Failed.  Response message = #{JSON.parse(error_response)['errors'].first['title']}.", error.message
        end
      end

      context '#run' do
        should 'call the api and pass params' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          stub_request(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/#{custom_signature.id}/run_existing.json*}).to_return(body: json_list(:alert, 2))

          alerts = custom_signature.run(regions: 'param2')

          assert_requested(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/#{custom_signature.id}/run_existing.json*}) do |req|
            body = JSON.parse req.body
            assert_equal custom_signature.id, body['data']['id']
            assert_equal ['param2'], body['data']['attributes']['regions']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'raise an error if external_account_id is not provided' do
          custom_signature = build(:custom_signature, external_account_id: nil)

          error = assert_raises ArgumentError do
            custom_signature.run(regions: 'param2')
          end

          assert_equal "You must supply an external_account_id.", error.message
        end

        should 'not throw an error if an error is returned' do
          custom_signature = build(:custom_signature, external_account_id: 3)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response)
          error.expects(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)
          stub_request(:post, %r{external_account/#{custom_signature.external_account_id}/custom_signatures/#{custom_signature.id}/run_existing.json*}).to_return(body: json_list(:alert, 2))

          assert_nothing_raised do
            result = custom_signature.run(regions: 'param2')
            assert_equal JSON.parse(error_response)['errors'].first['title'], result.errors.full_messages.first
          end
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

        context '#service' do
          should 'return a service' do
            service = @custom_signature.service

            assert_equal @custom_signature.service_id, service.id
            assert_equal ESP::Service, service.class
          end
        end

        context '#organization' do
          should 'return an organization' do
            organization = @custom_signature.organization

            assert_equal @custom_signature.organization_id, organization.id
            assert_equal ESP::Organization, organization.class
          end
        end

        context 'run_sanity_test' do
          should 'return alerts' do
            external_account_id = ESP::ExternalAccount.last.id
            alerts = ESP::CustomSignature.run_sanity_test(external_account_id: external_account_id, regions: 'us_east_1', language: @custom_signature.language, signature: @custom_signature.signature)

            assert_equal ESP::Alert, alerts.resource_class
          end

          should 'return errors' do
            signature = ESP::CustomSignature.run_sanity_test(external_account_id: 999, regions: 'us_east_1', language: @custom_signature.language, signature: @custom_signature.signature)

            assert_equal "Couldn't find ExternalAccount", signature.errors.full_messages.first
          end
        end

        context 'run' do
          should 'return alerts' do
            external_account_id = ESP::ExternalAccount.last.id
            alerts = @custom_signature.run(external_account_id: external_account_id, regions: ['us_east_1'])

            assert_equal ESP::Alert, alerts.resource_class
          end

          should 'return errors' do
            signature = @custom_signature.run(external_account_id: 999)

            assert_equal "Couldn't find ExternalAccount", signature.errors.full_messages.first
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

            assert_raises ActiveResource::ResourceInvalid do
              ESP::CustomSignature.find(custom_signature.id)
            end
          end
        end
      end
    end
  end
end
