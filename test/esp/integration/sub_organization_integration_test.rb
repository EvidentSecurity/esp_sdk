require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class SubOrganizationTest < ESP::Integration::TestCase
    context ESP::SubOrganization do
      context 'live calls' do
        setup do
          @sub_organization = ESP::SubOrganization.last
          skip "Live DB does not have any sub organizations.  Add a sub organization and run tests again." if @sub_organization.blank?
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

        context '.where' do
          should 'return sub_organization objects' do
            sub_organizations = ESP::SubOrganization.where(id_eq: @sub_organization.id)

            assert_equal ESP::SubOrganization, sub_organizations.resource_class
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
