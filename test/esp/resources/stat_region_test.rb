require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class Stat
    class RegionTest < ActiveSupport::TestCase
      context ESP::StatRegion do
        context '.where' do
          should 'not be implemented' do
            assert_raises ESP::NotImplementedError do
              StatRegion.where(id_eq: 2)
            end
          end
        end

        context '.for_stat' do
          should 'throw an error if stat id is not supplied' do
            error = assert_raises ArgumentError do
              ESP::StatRegion.for_stat
            end
            assert_equal 'You must supply a stat id.', error.message
          end

          should 'call the api' do
            stub_region = stub_request(:get, %r{stats/5/regions.json*}).to_return(body: json_list(:stat_region, 2))

            regions = ESP::StatRegion.for_stat(5)

            assert_requested(stub_region)
            assert_equal ESP::StatRegion, regions.resource_class
          end
        end

        context '.find' do
          should 'throw an error if stat_id is not supplied' do
            error = assert_raises ArgumentError do
              ESP::StatRegion.find(:all, params: { id: 3 })
            end
            assert_equal 'You must supply a stat id.', error.message
          end

          should 'call the show api and return a region if searching by id' do
            stub_region = stub_request(:get, %r{regions/5.json*}).to_return(body: json(:stat_region))

            region = ESP::StatRegion.find(5)

            assert_requested(stub_region)
            assert_equal ESP::StatRegion, region.class
          end

          should 'call the api and return regions when stat_id is supplied' do
            stub_region = stub_request(:get, %r{stats/5/regions.json*}).to_return(body: json_list(:stat_region, 2))

            regions = ESP::StatRegion.find(:all, params: { stat_id: 5 })

            assert_requested(stub_region)
            assert_equal ESP::StatRegion, regions.resource_class
          end
        end

        context '#create' do
          should 'not be implemented' do
            assert_raises ESP::NotImplementedError do
              ESP::StatRegion.create(name: 'test')
            end
          end
        end

        context '#update' do
          should 'not be implemented' do
            region = ESP::StatRegion.new
            assert_raises ESP::NotImplementedError do
              region.save
            end
          end
        end

        context '#destroy' do
          should 'not be implemented' do
            s = ESP::StatRegion.new
            assert_raises ESP::NotImplementedError do
              s.destroy
            end
          end
        end

        context '#region' do
          should 'call the show api and return the region' do
            region_stat = ESP::StatRegion.new(region_id: 3)

            stub_region = stub_request(:get, %r{regions/#{region_stat.region_id}.json*}).to_return(body: json(:region))

            region = region_stat.region

            assert_requested(stub_region)
            assert_equal ESP::Region, region.class
          end
        end
      end
    end
  end
end
