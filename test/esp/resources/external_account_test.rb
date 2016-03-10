require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class ExternalAccountTest < ActiveSupport::TestCase
    context ESP::ExternalAccount do
      context '#organization' do
        should 'call the api' do
          external_account = build(:external_account, organization_id: 4)
          stub_org = stub_request(:get, %r{organizations/#{external_account.organization_id}.json*}).to_return(body: json(:organization))

          external_account.organization

          assert_requested(stub_org)
        end
      end

      context '#sub_organization' do
        should 'call the api' do
          external_account = build(:external_account, sub_organization_id: 4)
          stub_sub_org = stub_request(:get, %r{sub_organizations/#{external_account.sub_organization_id}.json*}).to_return(body: json(:sub_organization))

          external_account.sub_organization

          assert_requested(stub_sub_org)
        end
      end

      context '#team' do
        should 'call the api' do
          external_account = build(:external_account, team_id: 4)
          stub_team = stub_request(:get, %r{teams/#{external_account.team_id}.json*}).to_return(body: json(:team))

          external_account.team

          assert_requested(stub_team)
        end
      end

      context '#scan_intervals' do
        should 'call the api for the external_account and the passed in params' do
          external_account = build(:external_account)
          stub_request(:get, %r{external_accounts/#{external_account.id}/scan_intervals.json*}).to_return(body: json_list(:scan_interval, 2))

          external_account.scan_intervals

          assert_requested(:get, %r{external_accounts/#{external_account.id}/scan_intervals.json*})
        end
      end

      context '#create' do
        should "use the external_id in the params if supplied" do
          stub_request(:post, /external_accounts.json*/).to_return(body: json(:external_account))

          ESP::ExternalAccount.create(external_id: '32145', name: 'bob')

          assert_requested(:post, /external_accounts.json*/) do |req|
            body = JSON.parse(req.body)
            assert_equal '32145', body['data']['attributes']['external_id']
          end
        end

        should "generate the external_id if not supplied in the params" do
          ESP::ExternalAccount.any_instance.stubs(:generate_external_id).returns('12345')
          stub_request(:post, /external_accounts.json*/).to_return(body: json(:external_account))

          ESP::ExternalAccount.create(name: 'bob')

          assert_requested(:post, /external_accounts.json*/) do |req|
            body = JSON.parse(req.body)
            assert_equal '12345', body['data']['attributes']['external_id']
          end
          assert_received(ESP::ExternalAccount.any_instance, :generate_external_id)
        end
      end
    end
  end
end
