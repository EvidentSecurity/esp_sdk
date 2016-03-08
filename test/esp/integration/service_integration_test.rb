require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class ServiceTest < ESP::Integration::TestCase
    context ESP::Service do
      context 'live calls' do
        setup do
          @service = ESP::Service.last
          skip "Live DB does not have any services.  Add a service and run tests again." if @service.blank?
        end

        context '#signatures' do
          should 'return an array of signatures' do
            signatures = @service.signatures

            assert_equal ESP::Signature, signatures.resource_class
          end
        end

        context '#CRUD' do
          should 'be able to read' do
            assert_not_nil @service, @service.inspect
          end
        end
      end
    end
  end
end
