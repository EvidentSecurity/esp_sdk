require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class SignatureTest < ESP::Integration::TestCase
    context ESP::Signature do
      context 'live calls' do
        setup do
          @signature = ESP::Signature.where(name_cont: 'heartbleed').last
          fail "Live DB does not have any signatures.  Add a signature and run tests again." if @signature.blank?
        end

        context '#service' do
          should 'return a service' do
            service = @signature.service

            assert_equal @signature.service_id, service.id
            assert_equal ESP::Service, service.class
          end
        end

        context '#run' do
          should 'return alerts' do
            skip "Can't run sigs on CI" if ENV['CI_SERVER']
            external_account_id = ESP::ExternalAccount.last.id

            alerts = @signature.run(external_account_id: external_account_id, region: 'us_east_1')

            assert_equal ESP::Alert, alerts.resource_class
          end

          should 'return errors' do
            external_account_id = 999_999_999_999

            @signature.run(external_account_id: external_account_id, region: 'us_east_1')

            assert_equal "Couldn't find ExternalAccount", @signature.errors.full_messages.first
          end
        end

        context '.where' do
          should 'return signature objects' do
            signatures = ESP::Signature.where(id_eq: @signature.id)

            assert_equal ESP::Signature, signatures.resource_class
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
