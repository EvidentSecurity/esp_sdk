require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class StatTest < ActiveSupport::TestCase
    context ESP::Stat do
      context '#find' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Stat.find(1)
          end
        end
      end

      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Stat.create(report_id: 1)
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          s = build(:stat)

          assert_raises ESP::NotImplementedError do
            s.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          s = build(:stat)

          assert_raises ESP::NotImplementedError do
            s.destroy
          end
        end
      end

      context '.for_report' do
        should 'raise an error if report_id is not provided' do
          error = assert_raises ArgumentError do
            ESP::Stat.for_report
          end
          assert_equal "You must supply a report id.", error.message
        end

        should 'call the api and return a stat' do
          stub_stat = stub_request(:get, %r{reports/5/stats.json*}).to_return(body: json(:stat))

          stat = ESP::Stat.for_report(5)

          assert_requested(stub_stat)
          assert_equal ESP::Stat, stat.class
        end
      end

      context '.latest_for_teams' do
        should 'call the api and return a collection of stats' do
          stub_stat = stub_request(:get, %r{stats/latest_for_teams.json*}).to_return(body: json_list(:stat, 2))

          stats = ESP::Stat.latest_for_teams

          assert_requested(stub_stat)
          assert_equal ESP::Stat, stats.resource_class
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @team = ESP::Team.last
          skip "Live DB does not have any teams.  Add a team and run tests again." if @team.blank?
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context 'for_report' do
          should 'return the stat for the report' do
            report = ESP::Report.last
            skip "Live DB does not have any reports.  Add a report with stats and run tests again." if report.blank?

            stat = ESP::Stat.for_report(report.id)

            assert_equal report.id, stat.report.id
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
