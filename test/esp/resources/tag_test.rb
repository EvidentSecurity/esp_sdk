require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class TagTest < ActiveSupport::TestCase
    context ESP::Tag do
      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Tag.create(name: 'test')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          tag = build(:tag)
          assert_raises ESP::NotImplementedError do
            tag.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          tag = build(:tag)
          assert_raises ESP::NotImplementedError do
            tag.destroy
          end
        end
      end

      context '.where' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            Tag.where(id_eq: 2)
          end
        end
      end

      context '.for_alert' do
        should 'throw an error if alert id is not supplied' do
          error = assert_raises ArgumentError do
            ESP::Tag.for_alert
          end
          assert_equal 'You must supply an alert id.', error.message
        end

        should 'call the api' do
          stub_tag = stub_request(:get, %r{alerts/5/tags.json*}).to_return(body: json_list(:tag, 2))

          tags = ESP::Tag.for_alert(5)

          assert_requested(stub_tag)
          assert_equal ESP::Tag, tags.resource_class
        end
      end

      context '.find' do
        should 'throw an error if alert_id is not supplied' do
          error = assert_raises ArgumentError do
            ESP::Tag.find(:all, params: { id: 3 })
          end
          assert_equal 'You must supply an alert id.', error.message
        end

        should 'call the show api and return a tag if searching by id' do
          stub_tag = stub_request(:get, %r{tags/5.json*}).to_return(body: json(:tag))

          tag = ESP::Tag.find(5)

          assert_requested(stub_tag)
          assert_equal ESP::Tag, tag.class
        end

        should 'call the api and return tags when alert_id is supplied' do
          stub_tag = stub_request(:get, %r{alerts/5/tags.json*}).to_return(body: json_list(:tag, 2))

          tags = ESP::Tag.find(:all, params: { alert_id: 5 })

          assert_requested(stub_tag)
          assert_equal ESP::Tag, tags.resource_class
        end
      end
    end
  end
end
