require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class ReportTest < ActiveSupport::TestCase
    context ESP::Report do
      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Report.create(status: 'queued')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          r = build(:report)

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
          stub_request(:get, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 2))

          report.alerts(status: 'pass')

          assert_requested(:get, %r{reports/#{report.id}/alerts.json*}) do |req|
            assert_equal "filter[status]=pass", URI.unescape(req.uri.query)
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

      context '.create_for_team' do
        should 'raise an error if team_id is not provided' do
          error = assert_raises ArgumentError do
            ESP::Report.create_for_team
          end
          assert_equal "You must supply a team id.", error.message
        end

        should 'call api and return a report' do
          stubbed_report = stub_request(:post, %r{teams/3/report.json*}).to_return(body: json(:report))

          report = ESP::Report.create_for_team(3)

          assert_requested(stubbed_report)
          assert_equal ESP::Report, report.class
        end

        should 'call the api and return an error if an error is returned' do
          stub_request(:post, %r{teams/3/report.json*}).to_return(body: json(:report))
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          ESP::Report.connection.expects(:post).raises(error)

          assert_nothing_raised do
            r = ESP::Report.create_for_team(3)
            assert_equal JSON.parse(error_response)['errors'].first['title'], r.errors.full_messages.first
          end
        end
      end

      context '.create_for_team!' do
        should 'raise an error if team_id is not provided' do
          error = assert_raises ArgumentError do
            ESP::Report.create_for_team!
          end
          assert_equal "You must supply a team id.", error.message
        end

        should 'call api and return a report' do
          stubbed_report = stub_request(:post, %r{teams/3/report.json*}).to_return(body: json(:report))

          report = ESP::Report.create_for_team!(3)

          assert_requested(stubbed_report)
          assert_equal ESP::Report, report.class
        end

        should 'call the api and throw an error if an error is returned' do
          stub_request(:post, %r{teams/3/report.json*}).to_return(body: json(:report))
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response, code: '400')
          error.stubs(:response).returns(response)
          ESP::Report.connection.expects(:post).raises(error)

          error = assert_raises ActiveResource::ResourceInvalid do
            ESP::Report.create_for_team!(3)
          end
          assert_equal "Failed.  Response code = 400.  Response message = #{JSON.parse(error_response)['errors'].first['title']}.", error.message
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @report = ESP::Report.last
          skip "Live DB does not have any reports.  Add a report and run tests again." if @report.blank?
        end

        teardown do
          WebMock.disable_net_connect!
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

        context '.create_for_team' do
          should 'return an error if a bad team_id is passed' do
            assert_nothing_raised do
              r = ESP::Report.create_for_team(999)
              assert_equal "Couldn't find Team", r.errors.full_messages.first
            end
          end
        end
      end
    end
  end
end