require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class UserTest < ESP::Integration::TestCase
    context ESP::User do
      context 'live calls' do
        setup do
          @user = ESP::User.last
          fail "Live DB does not have any users.  Add a user and run tests again." if @user.blank?
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '#organization' do
          should 'return an organization' do
            org = @user.organization

            assert_equal @user.organization_id, org.id
          end
        end

        context '#sub_organizations' do
          should 'return an array of sub_organizations' do
            sub_orgs = @user.sub_organizations

            assert_equal @user.sub_organization_ids.count, sub_orgs.count
            assert_equal @user.sub_organization_ids, sub_orgs.map(&:id)
          end
        end

        context '#teams' do
          should 'return an array of teams' do
            teams = @user.teams

            assert_equal @user.team_ids.count, teams.count
            assert_equal @user.team_ids.sort, teams.map(&:id).sort
          end
        end

        context '.where' do
          should 'return user objects' do
            users = ESP::User.where(id_eq: @user.id)

            assert_equal ESP::User, users.resource_class
          end
        end
      end
    end
  end
end
