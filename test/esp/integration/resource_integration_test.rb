require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class ResourceTest < ESP::Integration::TestCase
    context ESP::Resource do
      context 'live calls' do
        setup do
          @team = ESP::Team.last
          skip "Live DB does not have any teams.  Add a team and run tests again." if @team.blank?
        end

        context 'with ESP::Team' do
          context '.find' do
            should 'find a team' do
              t = ESP::Team.find(@team.id)

              assert_equal ESP::Team, t.class
              assert_equal @team.id, t.id
            end

            should 'find teams' do
              t = ESP::Team.find(:all, params: { id: @team.id })

              assert_equal ESP::Team, t.resource_class
              assert_equal 1, t.count
            end
          end

          context '.where' do
            should 'return teams' do
              teams = ESP::Team.where(id: @team.id)

              assert_equal ESP::Team, teams.resource_class
              assert_equal 1, teams.count
            end

            should 'return included object on first call' do
              teams = ESP::Team.where(id: @team.id, include: 'organization')

              assert_equal ESP::Organization, teams.first.attributes['organization'].class
            end

            should 'return multiple included objects on first call' do
              teams = ESP::Team.where(id: @team.id, include: 'sub_organization, organization')

              assert_equal ESP::Organization, teams.first.attributes['organization'].class
              assert_equal ESP::SubOrganization, teams.first.attributes['sub_organization'].class
            end
          end
        end
      end
    end
  end
end
