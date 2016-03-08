require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class StatTest < ESP::Integration::TestCase
    context ESP::Stat do
      context 'live calls' do
        setup do
          @report = ESP::Report.all.detect { |r| r.status == 'complete' }
          skip "Live DB does not have any reports.  Add a report with stats and run tests again." if @report.blank?
          @stat = ESP::Stat.for_report(@report.id)
        end

        context '#report' do
          should 'return a report' do
            report = @stat.report

            assert_equal @stat.report_id, report.id
          end
        end

        context '#regions' do
          should 'return regions' do
            regions = @stat.regions

            assert_equal ESP::StatRegion, regions.resource_class
          end
        end

        context '#services' do
          should 'return services' do
            services = @stat.services

            assert_equal ESP::StatService, services.resource_class
          end
        end

        context '#signatures' do
          should 'return signatures' do
            signatures = @stat.signatures

            assert_equal ESP::StatSignature, signatures.resource_class
          end
        end

        context '#custom_signautures' do
          should 'return custom_signautures' do
            custom_signatures = @stat.custom_signatures

            assert_equal ESP::StatCustomSignature, custom_signatures.resource_class
          end
        end

        context 'for_report' do
          should 'return the stat for the report' do
            assert_equal @report.id, @stat.report_id
          end
        end

        context '.latest_for_teams' do
          should 'return a collection of stats' do
            stats = ESP::Stat.latest_for_teams

            assert_equal ESP::Stat, stats.resource_class
          end
        end
      end
    end
  end
end
