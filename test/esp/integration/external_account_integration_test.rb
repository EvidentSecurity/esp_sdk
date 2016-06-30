require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class ExternalAccountTest < ESP::Integration::TestCase
    context ESP::ExternalAccount do
      context 'live calls' do
        setup do
          @external_account = ESP::ExternalAccount.last
          fail "Live DB does not have any external_accounts.  Add a external_account and run tests again." if @external_account.blank?
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

        context '#reports' do
          should 'return an array of reports' do
            reports = @external_account.reports

            assert_equal ESP::Report, reports.resource_class
          end
        end

        context '.where' do
          should 'return external_account objects' do
            external_accounts = ESP::ExternalAccount.where(id_eq: @external_account.id)

            assert_equal ESP::ExternalAccount, external_accounts.resource_class
          end
        end

        context '#CRUD' do
          should 'be able to create, update and destroy' do
            skip "There are to many dependencies to validate an external account to create or update one. Besides esp_web, esp_query has to be running and there must be valid AWS keys assigned as well."

            external_account = ESP::ExternalAccount.create(name: 'bob', arn: @external_account.arn, sub_organization_id: @external_account.sub_organization_id, team_id: @external_account.team_id)

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
