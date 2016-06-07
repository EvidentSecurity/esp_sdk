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

        context '.where' do
          should 'return external_account objects' do
            external_accounts = ESP::ExternalAccount.where(id_eq: @external_account.id)

            assert_equal ESP::ExternalAccount, external_accounts.resource_class
          end
        end
      end
    end
  end
end
