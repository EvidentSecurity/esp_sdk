require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class ServiceTest < ActiveSupport::TestCase
    context ESP::Service do
      context '#signatures' do
        context '.where' do
          should 'not be implemented' do
            assert_raises ESP::NotImplementedError do
              Tag.where(id_eq: 2)
            end
          end
        end

        should 'call the api' do
          s = build(:service)
          stub_request(:get, /signatures.json_api*/).to_return(body: json_list(:signature, 2))

          s.signatures

          assert_requested(:get, /signatures.json_api*/) do |req|
            assert_equal "filter[service_id_eq]=#{s.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Service.create(name: 'test')
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          s = build(:service)
          assert_raises ESP::NotImplementedError do
            s.destroy
          end
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @service = ESP::Service.last
          skip "Live DB does not have any services.  Add a service and run tests again." if @service.blank?
        end

        teardown do
          WebMock.disable_net_connect!
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
