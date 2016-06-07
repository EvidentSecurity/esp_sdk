require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class Report
    module Export
      class IntegrationTest < ESP::Integration::TestCase
        context ESP::Report::Export::Integration do
          context 'live calls' do
            context '#create' do
              should 'queue export' do
                report = ESP::Report.last
                fail "Live DB does not have any reports.  Add a report with stats and run tests again." if report.blank?

                response = ESP::Report::Export::Integration.create(integration_id: 1, report_ids: [report.id])

                assert_predicate response.errors, :blank?
              end
            end
          end
        end
      end
    end
  end
end
