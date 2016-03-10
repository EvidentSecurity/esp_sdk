require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class MetadataTest < ESP::Integration::TestCase
    context ESP::Metadata do
      context 'live calls' do
        context '.for_alert' do
          should 'return metadata for alert id' do
            report = ESP::Report.all.detect { |r| r.status == 'complete' }
            metadata = ESP::Metadata.for_alert(report.alerts.last.id)

            assert_equal ESP::Metadata, metadata.class
          end
        end
      end
    end
  end
end
