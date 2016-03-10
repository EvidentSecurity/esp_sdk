require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class TagTest < ESP::Integration::TestCase
    context ESP::Tag do
      context 'live calls' do
        context '.for_alert' do
          should 'return tags for alert id' do
            report = ESP::Report.all.detect { |r| r.status == 'complete' }
            events = ESP::Tag.for_alert(report.alerts.last.id)

            assert_equal ESP::Tag, events.resource_class
          end
        end
      end
    end
  end
end
