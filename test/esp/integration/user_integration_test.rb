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
            sub_orgs.map(&:id).each do |id|
              assert_contains @user.sub_organization_ids, id
            end
          end
        end

        context '#teams' do
          should 'return an array of teams' do
            teams = @user.teams

            assert_equal @user.team_ids.count, teams.count
            assert_equal @user.team_ids.sort, teams.map(&:id).sort
          end
        end

        context '#role' do
          should 'return an role' do
            role = @user.role

            assert_equal @user.role_id, role.id
          end
        end

        context '.where' do
          should 'return user objects' do
            users = ESP::User.where(id_eq: @user.id)

            assert_equal ESP::User, users.resource_class
          end
        end

        context '#CRUD' do
          should 'be able to create, update and destroy' do
            user = ESP::User.new(first_name: 'Bob', last_name: 'Belcher', email: 'burgerboss@gmail.com', organization_id: 1)

            assert_predicate user, :new?

            user.save

            refute_predicate user, :new?

            user.first_name = 'Gene'
            user.save

            assert_nothing_raised do
              ESP::User.find(user.id)
            end

            user.destroy

            assert_raises ActiveResource::ResourceNotFound do
              ESP::User.find(user.id)
            end
          end
        end
      end
    end
  end
end
