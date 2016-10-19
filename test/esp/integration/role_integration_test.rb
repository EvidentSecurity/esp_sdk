require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class RoleTest < ESP::Integration::TestCase
    context ESP::Role do
      context 'live calls' do
        setup do
          @role = ESP::Role.last
          fail "Live DB does not have any roles.  Add a role and run tests again." if @role.blank?
        end

        context '#CRUD' do
          should 'be able to read' do
            assert_not_nil @role

            role = ESP::Role.find(@role.id)

            assert_not_nil role
          end
        end
      end
    end
  end
end
