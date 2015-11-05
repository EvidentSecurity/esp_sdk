require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class SubOrganizationTest < ActiveSupport::TestCase
    context ESP::SubOrganization do
      context '#organization' do
        should 'call the api' do
          sub_organization = build(:sub_organization, organization_id: 4)
          stub_org = stub_request(:get, %r{organizations/#{sub_organization.organization_id}.json*}).to_return(body: json(:organization))

          sub_organization.organization

          assert_requested(stub_org)
        end
      end

      context '#teams' do
        should 'call the api' do
          sub_organization = build(:sub_organization, team_id: 4)
          stub_request(:get, /teams.json*/).to_return(body: json_list(:sub_organization, 2))

          sub_organization.teams

          assert_requested(:get, /teams.json*/) do |req|
            assert_equal "filter[sub_organization_id_eq]=#{sub_organization.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#external_accounts' do
        should 'call the api' do
          sub_organization = build(:sub_organization)
          stub_request(:get, /external_accounts.json*/).to_return(body: json_list(:external_account, 2))

          sub_organization.external_accounts

          assert_requested(:get, /external_accounts.json*/) do |req|
            assert_equal "filter[sub_organization_id_eq]=#{sub_organization.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#reports' do
        should 'call the api' do
          sub_organization = build(:sub_organization)
          stub_request(:get, /reports.json*/).to_return(body: json_list(:report, 2))

          sub_organization.reports

          assert_requested(:get, /reports.json*/) do |req|
            assert_equal "filter[sub_organization_id_eq]=#{sub_organization.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @sub_organization = ESP::SubOrganization.last
          skip "Live DB does not have any sub organizations.  Add a sub organization and run tests again." if @sub_organization.blank?
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '#organization' do
          should 'return an organization' do
            org = @sub_organization.organization

            assert_equal @sub_organization.organization_id, org.id
          end
        end

        context '#teams' do
          should 'return a sub_organization' do
            teams = @sub_organization.teams

            assert_equal ESP::Team, teams.resource_class
          end
        end

        context '#external_accounts' do
          should 'return an array of external_accounts' do
            external_accounts = @sub_organization.external_accounts

            assert_equal ESP::ExternalAccount, external_accounts.resource_class
          end
        end

        context '#reports' do
          should 'return an array of reports' do
            reports = @sub_organization.reports

            assert_equal ESP::Report, reports.resource_class
          end
        end

        context '#CRUD' do
          should 'be able to create, update and destroy' do
            sub_organization = ESP::SubOrganization.new(name: 'bob', organization_id: @sub_organization.organization_id)

            assert_predicate sub_organization, :new?

            sub_organization.save

            refute_predicate sub_organization, :new?

            sub_organization.name = 'jim'
            sub_organization.save

            assert_nothing_raised do
              ESP::SubOrganization.find(sub_organization.id)
            end

            sub_organization.destroy

            assert_raises ActiveResource::ResourceNotFound do
              ESP::SubOrganization.find(sub_organization.id)
            end
          end
        end
      end
    end
  end
end
