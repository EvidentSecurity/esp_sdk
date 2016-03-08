require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class MetadataTest < ActiveSupport::TestCase
    context ESP::Metadata do
      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Metadata.create(name: 'test')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          metadata = build(:metadata)
          assert_raises ESP::NotImplementedError do
            metadata.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          metadata = build(:metadata)
          assert_raises ESP::NotImplementedError do
            metadata.destroy
          end
        end
      end

      context '.for_alert' do
        should 'throw an error if alert id is not supplied' do
          error = assert_raises ArgumentError do
            ESP::Metadata.for_alert
          end
          assert_equal 'You must supply an alert id.', error.message
        end

        should 'call the api' do
          stub_event = stub_request(:get, %r{alerts/5/metadata.json*}).to_return(body: json_list(:metadata, 2))

          metadata = ESP::Metadata.for_alert(5)

          assert_requested(stub_event)
          assert_equal ESP::Metadata, metadata.class
        end
      end

      context '.find' do
        should 'throw an error if alert_id is not supplied' do
          error = assert_raises ArgumentError do
            ESP::Metadata.find(:all, params: { id: 3 })
          end
          assert_equal 'You must supply an alert id.', error.message
        end

        should 'call the show api and return metadata if searching by id' do
          stub_event = stub_request(:get, %r{metadata/5.json*}).to_return(body: json(:metadata))

          event = ESP::Metadata.find(5)

          assert_requested(stub_event)
          assert_equal ESP::Metadata, event.class
        end

        should 'call the api and return metadata when alert_id is supplied' do
          stub_event = stub_request(:get, %r{alerts/5/metadata.json*}).to_return(body: json_list(:metadata, 2))

          metadata = ESP::Metadata.find(:all, params: { alert_id: 5 })

          assert_requested(stub_event)
          assert_equal ESP::Metadata, metadata.class
        end
      end
    end
  end
end
