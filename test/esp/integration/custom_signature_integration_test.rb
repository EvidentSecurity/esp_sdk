require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class CustomSignatureTest < ESP::Integration::TestCase
    context ESP::CustomSignature do
      context 'live calls' do
        setup do
          @custom_signature = ESP::CustomSignature.last
          skip "Live DB does not have any custom_signatures.  Add a custom_signature and run tests again." if @custom_signature.blank?
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
            skip "Can't run sigs on CI" if ENV['CI_SERVER']
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
            skip "Can't run sigs on CI" if ENV['CI_SERVER']
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
            skip "Can't run sigs on CI" if ENV['CI_SERVER']
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
