require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module ESP
  class Suppression
    class RegionTest < ActiveSupport::TestCase
      context ESP::Suppression::Region do
        context '.where' do
          should 'not be implemented' do
            assert_raises ESP::NotImplementedError do
              ESP::Suppression::Region.where(id_eq: 2)
            end
          end
        end

        context '#find' do
          should 'not be implemented' do
            assert_raises ESP::NotImplementedError do
              ESP::Suppression::Region.find(4)
            end
          end
        end

        context '#update' do
          should 'not be implemented' do
            s = ESP::Suppression::Region.new
            assert_raises ESP::NotImplementedError do
              s.update
            end
          end
        end

        context '#destroy' do
          should 'not be implemented' do
            s = ESP::Suppression::Region.new
            assert_raises ESP::NotImplementedError do
              s.destroy
            end
          end
        end

        context '#create' do
          should 'call the api' do
            stub_request(:post, %r{suppressions/regions.json*}).to_return(body: json(:suppression_region))

            suppression = ESP::Suppression::Region.create(regions: ['us_east_1'], external_account_ids: [5], reason: 'because')

            assert_requested(:post, %r{suppressions/regions.json*}) do |req|
              body = JSON.parse(req.body)
              assert_equal 'because', body['data']['attributes']['reason']
              assert_equal ['us_east_1'], body['data']['attributes']['regions']
              assert_equal [5], body['data']['attributes']['external_account_ids']
            end
            assert_equal ESP::Suppression::Region, suppression.class
          end

          context 'for alert' do
            should 'call the api' do
              stub_request(:post, %r{suppressions/alert/5/regions.json*}).to_return(body: json(:suppression_region))

              suppression = ESP::Suppression::Region.create(alert_id: 5, reason: 'because')

              assert_requested(:post, %r{suppressions/alert/5/regions.json*}) do |req|
                body = JSON.parse(req.body)
                assert_equal 'because', body['data']['attributes']['reason']
              end
              assert_equal ESP::Suppression::Region, suppression.class
            end
          end
        end
      end
    end
  end
end
