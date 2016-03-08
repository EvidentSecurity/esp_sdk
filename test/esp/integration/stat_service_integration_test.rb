require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class Stat
    class ServiceTest < ESP::Integration::TestCase
      context ESP::StatService do
        context 'live calls' do
          context '#services' do
            should 'return signatures' do
              report = ESP::Report.all.detect { |r| r.status == 'complete' }
              skip "Live DB does not have any reports.  Add a report with stats and run tests again." if report.blank?
              stat = ESP::Stat.for_report(report.id)
              services = stat.services

              service = services.first.service

              assert_equal ESP::Service, service.class
              assert_equal services.first.service.name, service.name
            end
          end

          context '.for_stat' do
            should 'return tags for stat id' do
              report = ESP::Report.find(:first, params: { id_eq: 1 })
              skip "make sure you have a complete report" unless report.present?
              stat_id = report.stat.id
              stats = ESP::StatService.for_stat(stat_id)

              assert_equal ESP::StatService, stats.resource_class
            end
          end
        end
      end
    end
  end
end
