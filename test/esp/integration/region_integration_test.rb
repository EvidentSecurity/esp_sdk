require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class RegionTest < ESP::Integration::TestCase
    context ESP::Region do
      context 'live calls' do
        setup do
          @region = ESP::Region.last
          fail "Live DB does not have any regions.  Add a region and run tests again." if @region.blank?
        end

        context '.where' do
          should 'return region objects' do
            regions = ESP::Region.where(id_eq: @region.id)

            assert_equal ESP::Region, regions.resource_class
          end
        end

        context '#CRUD' do
          should 'be able to read' do
            assert_not_nil @region

            region = ESP::Region.find(@region.id)

            assert_not_nil region
          end
        end
      end
    end
  end
end
