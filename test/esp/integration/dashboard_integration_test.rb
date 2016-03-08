require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class DashboardTest < ESP::Integration::TestCase
    context ESP::Dashboard do
      context 'live calls' do
        context '.recent' do
          should 'return an array of contact_requests' do
            dashboards = ESP::Dashboard.recent

            assert_equal ESP::Dashboard, dashboards.resource_class
          end
        end
      end
    end
  end
end
