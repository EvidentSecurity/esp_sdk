require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class OrganizationTest < ESP::Integration::TestCase
    context ESP::Organization do
      context 'live calls' do
        setup do
          @organization = ESP::Organization.last
          fail "Live DB does not have any sub organizations.  Add a sub organization and run tests again." if @organization.blank?
        end

        context '#teams' do
          should 'return teams' do
            teams = @organization.teams

            assert_equal ESP::Team, teams.resource_class
          end
        end

        context '#sub_organizations' do
          should 'return a sub_organization' do
            sub_organizations = @organization.sub_organizations

            assert_equal ESP::SubOrganization, sub_organizations.resource_class
          end
        end

        context '#users' do
          should 'return an array of users' do
            users = @organization.users

            assert_equal ESP::User, users.resource_class
          end
        end

        context '#reports' do
          should 'return an array of reports' do
            reports = @organization.reports

            assert_equal ESP::Report, reports.resource_class
          end
        end

        context '#external_accounts' do
          should 'return an array of external_accounts' do
            external_accounts = @organization.external_accounts

            assert_equal ESP::ExternalAccount, external_accounts.resource_class
          end
        end

        context '#custom_signatures' do
          should 'return an array of custom_signatures' do
            custom_signatures = @organization.custom_signatures

            assert_equal ESP::CustomSignature, custom_signatures.resource_class
          end
        end

        context '.where' do
          should 'return organization objects' do
            organizations = ESP::Organization.where(id_eq: @organization.id)

            assert_equal ESP::Organization, organizations.resource_class
          end
        end

        context '#CRUD' do
          should 'be able to update' do
            @organization.name = @organization.name
            @organization.save

            assert_nothing_raised do
              ESP::Organization.find(@organization.id)
            end
          end
        end
      end
    end
  end
end
