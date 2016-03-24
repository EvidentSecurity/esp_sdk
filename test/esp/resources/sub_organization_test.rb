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
    end
  end
end
