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

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @external_account = ESP::ExternalAccount.last
          skip "Live DB does not have any external_accounts.  Add a external_account and run tests again." if @external_account.blank?
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '#organization' do
          should 'return an organization' do
            org = @external_account.organization

            assert_equal @external_account.organization_id, org.id
          end
        end

        context '#sub_organization' do
          should 'return a sub_organization' do
            sub_org = @external_account.sub_organization

            assert_equal @external_account.sub_organization_id, sub_org.id
          end
        end

        context '#team' do
          should 'return a team' do
            team = @external_account.team

            assert_equal ESP::Team, team.class
          end
        end

        context '#CRUD' do
          should 'be able to create, update and destroy' do
            # We can't randomly generate a valid arn, so we can't create on to be destroyed, but we can make the calls and test errors.
            external_account = ESP::ExternalAccount.create(nickname: 'bob', arn: @external_account.arn, sub_organization_id: @external_account.sub_organization_id, team_id: @external_account.team_id)

            assert_predicate external_account, :new?
            assert_contains external_account.errors, "The account for this ARN is already being checked by Dev"

            refute_predicate @external_account, :new?
            @external_account.name = @external_account.name

            assert_predicate @external_account, :save

            external_account = build(:external_account, id: 999)

            assert_raises ActiveResource::ResourceNotFound do
              external_account.destroy
            end
          end
        end
      end
    end
  end
end
