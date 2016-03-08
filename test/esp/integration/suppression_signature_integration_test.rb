require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class Suppression
    class SignatureTest < ESP::Integration::TestCase
      context ESP::Suppression::Signature do
        context 'live calls' do
          context '.create' do
            should 'return error when reason is not supplied' do
              signature_id = ESP::Signature.last.id
              external_account_id = ESP::ExternalAccount.last.id

              suppression = ESP::Suppression::Signature.create(signature_ids: [signature_id], custom_signature_ids: [], regions: ['us_east_1'], external_account_ids: [external_account_id])

              assert_equal "Reason can't be blank", suppression.errors.full_messages.first
            end

            should 'return suppression' do
              signature_id = ESP::Signature.last.id
              external_account_id = ESP::ExternalAccount.last.id

              suppression = ESP::Suppression::Signature.create(signature_ids: [signature_id], custom_signature_ids: [], reason: 'test', regions: ['us_east_1'], external_account_ids: [external_account_id])

              assert_equal ESP::Suppression::Signature, suppression.class
            end

            context 'for_alert' do
              should 'return error when reason is not supplied' do
                alert_id = ESP::Report.all.detect { |r| r.status == 'complete' }.alerts.last.id

                suppression = ESP::Suppression::Signature.create(alert_id: alert_id)

                assert_equal "Reason can't be blank", suppression.errors.full_messages.first
              end

              should 'return suppression' do
                alert_id = ESP::Report.all.detect { |r| r.status == 'complete' }.alerts.last.id

                suppression = ESP::Suppression::Signature.create(alert_id: alert_id, reason: 'test')

                assert_predicate suppression.errors, :blank?
                assert_equal ESP::Suppression::Signature, suppression.class
              end
            end
          end
        end
      end
    end
  end
end
