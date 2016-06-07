require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class CustomSignatureResultTest < ESP::Integration::TestCase
    context ESP::CustomSignature::Result do
      context 'live calls' do
        context '#definition' do
          should 'return a definition' do
            result = ESP::CustomSignature::Result.last
            fail 'Missing result' if result.blank?

            definition = result.definition

            assert_equal ESP::CustomSignature::Definition, definition.class
            assert_equal result.definition_id, definition.id
          end
        end

        context '#region' do
          should 'return a region' do
            result = ESP::CustomSignature::Result.last
            fail 'Missing result' if result.blank?

            region = result.region

            assert_equal ESP::Region, region.class
            assert_equal result.region_id, region.id
          end
        end

        context '#external_account' do
          should 'return a external_account' do
            result = ESP::CustomSignature::Result.last
            fail 'Missing result' if result.blank?

            external_account = result.external_account

            assert_equal ESP::ExternalAccount, external_account.class
            assert_equal result.external_account_id, external_account.id
          end
        end

        context '#alerts' do
          should 'return list of alerts' do
            result = ESP::CustomSignature::Result.last
            fail 'Missing result' if result.blank?

            alerts = result.alerts

            assert_equal ESP::CustomSignature::Result::Alert, alerts.resource_class
          end
        end

        context '.where' do
          should 'return result objects' do
            result = ESP::CustomSignature::Result.last
            fail 'Missing result' if result.blank?

            results = ESP::CustomSignature::Result.where(id_eq: result.id)

            assert_equal ESP::CustomSignature::Result, results.resource_class
          end
        end

        context '#create' do
          should 'be able to create' do
            custom_signature = ESP::CustomSignature.create(name: 'ABC', identifier: 'ABC', risk_level: 'High')
            refute_predicate custom_signature, :new?
            definition = custom_signature.definitions.first
            fail 'Missing definition' if definition.blank?
            result = ESP::CustomSignature::Result.new(custom_signature_definition_id: definition.id, external_account_id: 1, region_id: 1, code: 'abc', language: 'ruby')

            assert_predicate result, :new?

            result.save

            refute_predicate result, :new?
          end
        end
      end
    end
  end
end
