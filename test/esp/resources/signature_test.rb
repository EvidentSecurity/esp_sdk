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

      context '.run' do
        should 'call the api and pass params' do
          stub_request(:post, %r{external_account/3/signatures/run.json*}).to_return(body: json_list(:alert, 2))

          alerts = ESP::Signature.run(external_account_id: 3, signature_name: 'param1', regions: 'param2')

          assert_requested(:post, %r{external_account/3/signatures/run.json}) do |req|
            body = JSON.parse req.body
            assert_equal 'param1', body['data']['attributes']['signature_name']
            assert_equal ['param2'], body['data']['attributes']['regions']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'raise an error if external_account_id is not provided' do
          error = assert_raises ArgumentError do
            ESP::Signature.run(signature_name: 'param1', regions: 'param2')
          end

          assert_equal "You must supply an external_account_id.", error.message
        end

        should 'not throw an error if an error is returned' do
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)

          assert_nothing_raised do
            result = ESP::Signature.run(external_account_id: 3, signature_name: 'param1', regions: 'param2')
            assert_equal JSON.parse(error_response)['errors'].first['title'], result.errors.full_messages.first
          end
        end
      end

      context '.run!' do
        should 'call the api and pass params' do
          stub_request(:post, %r{external_account/3/signatures/run.json*}).to_return(body: json_list(:alert, 2))

          alerts = ESP::Signature.run!(external_account_id: 3, signature_name: 'param1', regions: 'param2')

          assert_requested(:post, %r{external_account/3/signatures/run.json}) do |req|
            body = JSON.parse req.body
            assert_equal 'param1', body['data']['attributes']['signature_name']
            assert_equal ['param2'], body['data']['attributes']['regions']
          end
          assert_equal ESP::Alert, alerts.resource_class
        end

        should 'raise an error if external_account_id is not provided' do
          error = assert_raises ArgumentError do
            ESP::Signature.run!(signature_name: 'param1', regions: 'param2')
          end

          assert_equal "You must supply an external_account_id.", error.message
        end

        should 'throw an error if an error is returned' do
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          ActiveResource::Connection.any_instance.expects(:post).raises(error)

          error = assert_raises ActiveResource::ResourceInvalid do
            result = ESP::Signature.run!(external_account_id: 3, signature_name: 'param1', regions: 'param2')
            assert_equal JSON.parse(error_response)['errors'].first['title'], result.errors.full_messages.first
          end
          assert_equal "Failed.  Response code = 400.  Response message = #{JSON.parse(error_response)['errors'].first['title']}.", error.message
        end
      end

      context '.names' do
        should 'call the api' do
          stub_names = stub_request(:get, %r{signatures/signature_names.json*}).to_return(body: { data: %w(name1 name2) }.to_json)

          ESP::Signature.names

          assert_requested(stub_names)
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
            name = ESP::Signature.names.first
            external_account_id = ESP::ExternalAccount.last.id

            alerts = ESP::Signature.run(external_account_id: external_account_id, signature_name: name, regions: 'us_east_1')

            assert_equal ESP::Alert, alerts.resource_class
          end

          should 'return errors' do
            name = ESP::Signature.names.first
            external_account_id = 999

            signature = ESP::Signature.run(external_account_id: external_account_id, signature_name: name, regions: ['us_east_1'])

            assert_equal "Couldn't find ExternalAccount", signature.errors.full_messages.first
          end
        end

        context '.names' do
          should 'return the list of names' do
            names = ESP::Signature.names

            assert_equal Array, names.class
          end
        end

        context '#CRUD' do
          should 'be able to create, update and destroy' do
            service_id = ESP::Service.last.id
            signature = ESP::Signature.new(name: 'bob', identifier: 'identifier', provider: 'provider', scope: 'scope', risk_level: 'Low', description: 'description', resolution: 'resolution', service_id: service_id)

            assert_predicate signature, :new?

            signature.save

            refute_predicate signature, :new?

            signature.name = 'jim'
            signature.save

            assert_nothing_raised do
              ESP::Signature.find(signature.id)
            end

            signature.destroy

            assert_raises ActiveResource::ResourceInvalid do
              ESP::Signature.find(signature.id)
            end
          end
        end
      end
    end
  end
end
