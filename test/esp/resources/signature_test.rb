require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class SignatureTest < ActiveSupport::TestCase
    context ESP::Signature do
      context '#service' do
        should 'call the api' do
          s = build(:signature, service_id: 4)
          stubbed_service = stub_request(:get, %r{services/#{s.service_id}.json*}).to_return(body: json(:service))

          s.service

          assert_requested(stubbed_service)
        end
      end

      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Signature.create(name: 'test')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          signature = build(:signature)
          assert_raises ESP::NotImplementedError do
            signature.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          s = build(:signature)
          assert_raises ESP::NotImplementedError do
            s.destroy
          end
        end
      end

      context '#run' do
        should 'call the api and pass params' do
          signature = build(:signature)
          stub_request(:post, %r{signatures/#{signature.id}/run.json*}).to_return(body: json_list(:alert, 2))

          alerts = signature.run(external_account_id: 3, region: 'param2')

          assert_requested(:post, %r{signatures/#{signature.id}/run.json}) do |req|
            body = JSON.parse req.body
            assert_equal 3, body['data']['attributes']['external_account_id']
            assert_equal 'param2', body['data']['attributes']['region']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'not throw an error if an error is returned' do
          signature = build(:signature)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)

          assert_nothing_raised do
            result = signature.run(external_account_id: 3, region: 'param2')
            assert_equal JSON.parse(error_response)['errors'].first['title'], result.errors.full_messages.first
          end
        end
      end

      context '.run!' do
        should 'call the api and pass params' do
          signature = build(:signature)
          stub_request(:post, %r{signatures/#{signature.id}/run.json*}).to_return(body: json_list(:alert, 2))

          alerts = signature.run!(external_account_id: 3, region: 'param2')

          assert_requested(:post, %r{signatures/#{signature.id}/run.json}) do |req|
            body = JSON.parse req.body
            assert_equal 3, body['data']['attributes']['external_account_id']
            assert_equal 'param2', body['data']['attributes']['region']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'throw an error if an error is returned' do
          signature = build(:signature)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)

          error = assert_raises ActiveResource::ResourceInvalid do
            result = signature.run!(external_account_id: 3, region: 'param2')
            assert_equal JSON.parse(error_response)['errors'].first['title'], result.errors.full_messages.first
          end
          assert_equal "Failed.  Response code = 400.  Response message = #{JSON.parse(error_response)['errors'].first['title']}.", error.message
        end
      end

      context '#suppress' do
        should 'call the api' do
          stub_request(:post, %r{suppressions/signatures.json*}).to_return(body: json(:suppression_signature))
          signature = build(:signature)

          suppression = signature.suppress(regions: ['us_east_1'], external_account_ids: [5], reason: 'because')

          assert_requested(:post, %r{suppressions/signatures.json*}) do |req|
            body = JSON.parse(req.body)
            assert_equal 'because', body['data']['attributes']['reason']
            assert_equal [signature.id], body['data']['attributes']['signature_ids']
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
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '#service' do
          should 'return a service' do
            signature = ESP::Signature.first

            service = signature.service

            assert_equal signature.service_id, service.id
            assert_equal ESP::Service, service.class
          end
        end

        context '#run' do
          should 'return alerts' do
            signature = ESP::Signature.first
            external_account_id = ESP::ExternalAccount.last.id

            alerts = signature.run(external_account_id: external_account_id, region: 'us_east_1')

            assert_equal ESP::Alert, alerts.resource_class
          end

          should 'return errors' do
            signature = ESP::Signature.first
            external_account_id = 999999999999

            signature = signature.run(external_account_id: external_account_id, region: 'us_east_1')

            assert_equal "Couldn't find ExternalAccount", signature.errors.full_messages.first
          end
        end

        context '#CRUD' do
          should 'be able to read' do
            signature = ESP::Signature.last

            assert_not_nil signature

            signature = ESP::Signature.find(signature.id)

            assert_not_nil signature
          end
        end
      end
    end
  end
end
