require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class DashboardTest < ActiveSupport::TestCase
    context ESP::Dashboard do
      context '#find' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Dashboard.find(4)
          end
        end
      end

      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Dashboard.create(name: 'test')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          d = build(:dashboard)
          assert_raises ESP::NotImplementedError do
            d.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          d = build(:dashboard)
          assert_raises ESP::NotImplementedError do
            d.destroy
          end
        end
      end

      context '.recent' do
        should 'call the api and return an array of dashboard objects' do
          stubbed_dashboard = stub_request(:get, %r{dashboard/recent.json*}).to_return(body: json_list(:dashboard, 2))

          dashboard = ESP::Dashboard.recent

          assert_requested(stubbed_dashboard)
          assert_equal ESP::Dashboard, dashboard.resource_class
        end
      end

      context '.timewarp' do
        should 'call the api passing the time param and return an array of dashboard objects' do
          stub_request(:get, %r{dashboard/timewarp.json*}).to_return(body: json_list(:dashboard, 2))

          start_time = 2.hours.ago
          dashboard = ESP::Dashboard.timewarp(start_time)

          assert_requested(:get, %r{dashboard/timewarp.json*}) do |req|
            assert_equal "filter[time]=#{start_time.to_i}", URI.unescape(req.uri.query)
          end
          assert_equal ESP::Dashboard, dashboard.resource_class
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '.recent' do
          should 'return an array of contact_requests' do
            dashboards = ESP::Dashboard.recent

            assert_equal ESP::Dashboard, dashboards.resource_class
          end
        end

        context '.timewarp' do
          should 'raise an error if start_of_window is not provided' do
            error = assert_raises ArgumentError do
              ESP::Dashboard.timewarp
            end
            assert_equal "You must supply a start time.", error.message
          end

          should 'return an array of contact_requests' do
            dashboards = ESP::Dashboard.timewarp(2.hours.ago)

            assert_equal ESP::Dashboard, dashboards.resource_class
          end
        end
      end
    end
  end
end
