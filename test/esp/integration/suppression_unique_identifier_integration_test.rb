require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class Suppression
    class UniqueIdentifierTest < ESP::Integration::TestCase
      context ESP::Suppression::UniqueIdentifier do
        context 'live calls' do
          context '.create' do
            should 'return error when reason is not supplied' do
              alert_id = ESP::Report.all.detect { |r| r.status == 'complete' }.alerts.last.id

              suppression = ESP::Suppression::UniqueIdentifier.create(alert_id: alert_id)

              assert_equal "Suppression reason can't be blank", suppression.errors.full_messages.first
            end

            should 'return suppression' do
              alert_id = ESP::Report.all.detect { |r| r.status == 'complete' }.alerts.last.id

              suppression = ESP::Suppression::UniqueIdentifier.create(alert_id: alert_id, reason: 'test')

              assert_predicate suppression.errors, :blank?
              assert_equal ESP::Suppression::UniqueIdentifier, suppression.class
            end
          end
        end
      end
    end
  end
end
