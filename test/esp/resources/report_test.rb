require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class ReportTest < ActiveSupport::TestCase
    context ESP::Report do
      context '#update' do
        should 'not be implemented' do
          r = build(:report)
          r.stubs(:new?).returns(false)

          assert_raises ESP::NotImplementedError do
            r.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          r = build(:report)

          assert_raises ESP::NotImplementedError do
            r.destroy
          end
        end
      end

      context '#organization' do
        should 'call the api' do
          report = build(:report, organization_id: 4)
          stub_org = stub_request(:get, %r{organizations/#{report.organization_id}.json*}).to_return(body: json(:organization))

          report.organization

          assert_requested(stub_org)
        end
      end

      context '#sub_organization' do
        should 'call the api' do
          report = build(:report, sub_organization_id: 4)
          stub_sub_org = stub_request(:get, %r{sub_organizations/#{report.sub_organization_id}.json*}).to_return(body: json(:sub_organization))

          report.sub_organization

          assert_requested(stub_sub_org)
        end
      end

      context '#team' do
        should 'call the api' do
          report = build(:report, team_id: 4)
          stub_team = stub_request(:get, %r{teams/#{report.team_id}.json*}).to_return(body: json(:team))

          report.team

          assert_requested(stub_team)
        end
      end

      context '#alerts' do
        should 'call the api for the report and the passed in params' do
          report = build(:report)
          stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 2))

          report.alerts(status: 'pass')

          assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
            body = JSON.parse(req.body)
            assert_equal 'pass', body['filter']['status']
          end
        end
      end

      context '#stat' do
        should 'call the api and return a stat' do
          report = build(:report)
          stub_stat = stub_request(:get, %r{reports/#{report.id}/stats.json*}).to_return(body: json(:stat))

          stat = report.stat

          assert_requested(stub_stat)
          assert_equal ESP::Stat, stat.class
        end
      end

      context '.create' do
        should 'raise an error if team_id is not provided' do
          error = assert_raises ArgumentError do
            ESP::Report.create
          end
          assert_equal "You must supply a team id.", error.message
        end

        should 'call api and return a report' do
          stubbed_report = stub_request(:post, /reports.json*/).to_return(body: json(:report))

          report = ESP::Report.create(team_id: 3)

          assert_requested(stubbed_report)
          assert_equal ESP::Report, report.class
        end

        should 'call the api and return an error if an error is returned' do
          stub_request(:post, /reports.json*/).to_return(body: json(:report))
          error = ActiveResource::ResourceInvalid.new('oh boy')
          error_response = json(:error)
          response = mock(body: error_response)
          error.stubs(:response).returns(response)
          ESP::Report.connection.expects(:post).raises(error)

          assert_nothing_raised do
            r = ESP::Report.create(team_id: 3)
            assert_equal JSON.parse(error_response)['errors'].first['title'], r.errors.full_messages.first
          end
        end
      end
    end
  end
end
