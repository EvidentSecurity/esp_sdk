require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class Stat
    class RegionTest < ESP::Integration::TestCase
      context ESP::StatRegion do
        context 'live calls' do
          context '#regions' do
            should 'return regions' do
              report = ESP::Report.all.detect { |r| r.status == 'complete' }
              skip "Live DB does not have any reports.  Add a report with stats and run tests again." if report.blank?
              stat = ESP::Stat.for_report(report.id)
              regions = stat.regions

              region = regions.first.region

              assert_equal ESP::Region, region.class
              assert_equal regions.first.region.code, region.code
            end
          end

          context '.for_stat' do
            should 'return tags for stat id' do
              report = ESP::Report.all.detect { |r| r.status == 'complete' }
              skip "make sure you have a complete report" unless report.present?
              stat_id = report.stat.id
              stats = ESP::StatRegion.for_stat(stat_id)

              assert_equal ESP::StatRegion, stats.resource_class
            end
          end
        end
      end
    end
  end
end
