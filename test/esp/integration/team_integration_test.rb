require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class TeamTest < ESP::Integration::TestCase
    context ESP::Team do
      context 'live calls' do
        setup do
          @team = ESP::Team.last
          fail "Live DB does not have any teams.  Add a team and run tests again." if @team.blank?
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

        context '#custom_signatures' do
          should 'return an array of custom_signatures' do
            custom_signatures = @team.custom_signatures

            assert_equal ESP::CustomSignature, custom_signatures.resource_class
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
