require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class CloudTrailEventTest < ESP::Integration::TestCase
    context ESP::CloudTrailEvent do
      context 'live calls' do
        context '.for_alert' do
          should 'return events for alert id' do
            report = ESP::Report.all.detect { |r| r.status == 'complete' }
            events = ESP::CloudTrailEvent.for_alert(report.alerts.last.id)

            assert_equal ESP::CloudTrailEvent, events.resource_class
          end
        end
      end
    end
  end
end
