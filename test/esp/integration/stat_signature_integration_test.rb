require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class Stat
    class SignatureTest < ESP::Integration::TestCase
      context ESP::StatSignature do
        context 'live calls' do
          context '#signatures' do
            should 'return signatures' do
              report = ESP::Report.all.detect { |r| r.status == 'complete' }
              skip "Live DB does not have any reports.  Add a report with stats and run tests again." if report.blank?
              stat = ESP::Stat.for_report(report.id)
              signatures = stat.signatures

              signature = signatures.first.signature

              assert_equal ESP::Signature, signature.class
              assert_equal signatures.first.signature.name, signature.name
            end
          end

          context '.for_stat' do
            should 'return tags for stat id' do
              report = ESP::Report.all.detect { |r| r.status == 'complete' }
              skip "make sure you have a complete report" unless report.present?
              stat_id = report.stat.id
              stats = ESP::StatSignature.for_stat(stat_id)

              assert_equal ESP::StatSignature, stats.resource_class
            end
          end
        end
      end
    end
  end
end
