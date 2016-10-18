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

      context '.where' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Dashboard.where(id_eq: 2)
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
          stubbed_dashboard = stub_request(:put, %r{dashboard/recent*}).to_return(body: json_list(:dashboard, 2))

          dashboard = ESP::Dashboard.recent

          assert_requested(stubbed_dashboard)
          assert_equal ESP::Dashboard, dashboard.resource_class
        end

        context 'next_page' do
          should 'request page 2 when multiple dashboards' do
            stub_dashboard = stub_request(:put, %r{dashboard/recent*}).with(body: {}.to_json).to_return(body: json_list(:dashboard, 25))
            stub_dashboard2 = stub_request(:put, %r{dashboard/recent*}).with(body: { filter: {}, page: { number: '2', size: '20' } }.to_json).to_return(body: json_list(:stat, 2))

            dashboard = ESP::Dashboard.recent
            dashboard.next_page

            assert_requested(stub_dashboard)
            assert_requested(stub_dashboard2)
          end
        end
      end
    end
  end
end
