require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class TeamTest < ActiveSupport::TestCase
    context ESP::Team do
      context '#organization' do
        should 'call the api' do
          team = build(:team, organization_id: 4)
          stub_org = stub_request(:get, %r{organizations/#{team.organization_id}.json*}).to_return(body: json(:organization))

          team.organization

          assert_requested(stub_org)
        end
      end

      context '#sub_organization' do
        should 'call the api' do
          team = build(:team, sub_organization_id: 4)
          stub_sub_org = stub_request(:get, %r{sub_organizations/#{team.sub_organization_id}.json*}).to_return(body: json(:sub_organization))

          team.sub_organization

          assert_requested(stub_sub_org)
        end
      end

      context '#external_accounts' do
        should 'call the api' do
          team = build(:team)
          stub_request(:get, /external_accounts.json*/).to_return(body: json_list(:external_account, 2))

          team.external_accounts

          assert_requested(:get, /external_accounts.json*/) do |req|
            assert_equal "filter[team_id_eq]=#{team.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#reports' do
        should 'call the api' do
          team = build(:team)
          stub_request(:get, /reports.json*/).to_return(body: json_list(:report, 2))

          team.reports

          assert_requested(:get, /reports.json*/) do |req|
            assert_equal "filter[team_id_eq]=#{team.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#create_report' do
        should 'call Report.create_for_team' do
          Report.stubs(:create_for_team)
          team = build(:team)

          team.create_report

          assert_received(Report, :create_for_team) do |expects|
            expects.with do |id|
              assert_equal team.id, id
            end
          end
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

        context '#organization' do
          should 'return an organization' do
            org = @team.organization

            assert_equal @team.organization_id, org.id
          end
        end

        context '#sub_organization' do
          should 'return a sub_organization' do
            sub_org = @team.sub_organization

            assert_equal @team.sub_organization_id, sub_org.id
          end
        end

        context '#external_accounts' do
          should 'return an array of external_accounts' do
            external_accounts = @team.external_accounts

            assert_equal ESP::ExternalAccount, external_accounts.resource_class
          end
        end

        context '#reports' do
          should 'return an array of reports' do
            reports = @team.reports

            assert_equal ESP::Report, reports.resource_class
          end
        end

        context '.where' do
          should 'return team objects' do
            teams = ESP::Team.where(name_eq: @team.name)

            assert_equal ESP::Team, teams.resource_class
          end
        end

        context '#CRUD' do
          should 'be able to create, update and destroy' do
            team = ESP::Team.new(name: 'bob', organization_id: @team.organization_id, sub_organization_id: @team.sub_organization_id)

            assert_predicate team, :new?

            team.save

            refute_predicate team, :new?

            team.name = 'jim'
            team.save

            assert_nothing_raised do
              ESP::Team.find(team.id)
            end

            team.destroy

            assert_raises ActiveResource::ResourceNotFound do
              ESP::Team.find(team.id)
            end
          end
        end
      end
    end
  end
end
