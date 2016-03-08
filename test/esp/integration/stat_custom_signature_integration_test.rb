require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class Stat
    class CustomSignatureTest < ESP::Integration::TestCase
      context ESP::StatCustomSignature do
        context 'live calls' do
          context '.for_stat' do
            should 'return tags for stat id' do
              report = ESP::Report.find(:first, params: { id_eq: 1 })
              skip "make sure you have a complete report" unless report.present?
              stat_id = report.stat.id
              stats = ESP::StatCustomSignature.for_stat(stat_id)

              assert_equal ESP::StatCustomSignature, stats.resource_class
            end
          end
        end
      end
    end
  end
end
