require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class CustomSignatureResultAlertTest < ESP::Integration::TestCase
    context ESP::CustomSignature::Result::Alert do
      context 'live calls' do
        context '#for_result' do
          should 'return alerts' do
            result = ESP::CustomSignature::Result.first
            fail 'Missing result' if result.blank?

            alerts = ESP::CustomSignature::Result::Alert.for_result(result.id)

            assert_equal ESP::CustomSignature::Result::Alert, alerts.resource_class
          end
        end

        context '#custom_signature' do
          should 'return a custom_signature' do
            result = ESP::CustomSignature::Result.first
            fail 'Missing result' if result.blank?
            alert = ESP::CustomSignature::Result::Alert.for_result(result.id).first

            custom_signature = alert.custom_signature

            assert_equal ESP::CustomSignature, custom_signature.class
            assert_equal alert.custom_signature_id, custom_signature.id
          end
        end

        context '#external_account' do
          should 'return a external_account' do
            result = ESP::CustomSignature::Result.first
            fail 'Missing result' if result.blank?
            alert = ESP::CustomSignature::Result::Alert.for_result(result.id).first

            external_account = alert.external_account

            assert_equal ESP::ExternalAccount, external_account.class
            assert_equal alert.external_account_id, external_account.id
          end
        end

        context '#region' do
          should 'return a region' do
            result = ESP::CustomSignature::Result.first
            fail 'Missing result' if result.blank?
            alert = ESP::CustomSignature::Result::Alert.for_result(result.id).first

            region = alert.region

            assert_equal ESP::Region, region.class
            assert_equal alert.region_id, region.id
          end
        end
      end
    end
  end
end
