require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

module ESP
  class Report
    module Export
      class IntegrationTest < ActiveSupport::TestCase
        context ESP::Report::Export::Integration do
          context '.where' do
            should 'not be implemented' do
              assert_raises ESP::NotImplementedError do
                ESP::Report::Export::Integration.where(id_eq: 2)
              end
            end
          end

          context '#find' do
            should 'not be implemented' do
              assert_raises ESP::NotImplementedError do
                ESP::Report::Export::Integration.find(4)
              end
            end
          end

          context '#update' do
            should 'not be implemented' do
              s = ESP::Report::Export::Integration.new
              assert_raises ESP::NotImplementedError do
                s.update
              end
            end
          end

          context '#destroy' do
            should 'not be implemented' do
              s = ESP::Report::Export::Integration.new
              assert_raises ESP::NotImplementedError do
                s.destroy
              end
            end
          end

          context '#create' do
            should 'call the api' do
              stub_request(:post, %r{reports/export/integrations.json*}).to_return(body: { success: 'Your export has been started' }.to_json)

              ESP::Report::Export::Integration.create(integration_id: 1, region_ids: [1])

              assert_requested(:post, %r{reports/export/integrations.json*})
            end
          end
        end
      end
    end
  end
end
