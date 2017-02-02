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
          stub_request(:get, /signatures.json*/).to_return(body: json_list(:signature, 2))

          s.signatures

          assert_requested(:get, /signatures.json*/) do |req|
            assert_equal "filter[service_id_eq]=#{s.id}", URI::DEFAULT_PARSER.unescape(req.uri.query)
          end
        end
      end

      context '.where' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Service.where(id_eq: 1)
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
    end
  end
end
