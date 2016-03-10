require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class ReportTest < ESP::Integration::TestCase
    context ESP::Report do
      context 'live calls' do
        setup do
          @report = ESP::Report.all.detect { |r| r.status == 'complete' }
          fail "Live DB does not have any reports.  Add a report and run tests again." if @report.blank?
        end

        context '#organization' do
          should 'return an organization' do
            org = @report.organization

            assert_equal @report.organization_id, org.id
          end
        end

        context '#sub_organization' do
          should 'return a sub_organization' do
            sub_org = @report.sub_organization

            assert_equal @report.sub_organization_id, sub_org.id
          end
        end

        context '#team' do
          should 'return a team' do
            team = @report.team

            assert_equal ESP::Team, team.class
          end
        end

        context '#alerts' do
          should 'return an array of alerts' do
            alerts = @report.alerts

            assert_equal ESP::Alert, alerts.resource_class
          end
        end

        context '#stat' do
          should 'return a stat' do
            stat = @report.stat

            assert_equal ESP::Stat, stat.class
          end
        end

        context '.where' do
          should 'return report objects' do
            reports = ESP::Report.where(id_eq: @report.id)

            assert_equal ESP::Report, reports.resource_class
          end
        end

        context '.create' do
          should 'return an error if a bad team_id is passed' do
            assert_nothing_raised do
              r = ESP::Report.create(team_id: 999)
              assert_equal "Couldn't find Team", r.errors.full_messages.first
            end
          end
        end
      end
    end
  end
end
