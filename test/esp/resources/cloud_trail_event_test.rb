require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class CloudTrailEventTest < ActiveSupport::TestCase
    context ESP::CloudTrailEvent do
      context '.where' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::CloudTrailEvent.where(id_eq: 2)
          end
        end
      end

      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::CloudTrailEvent.create(name: 'test')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          cloud_trail_event = build(:cloud_trail_event)
          assert_raises ESP::NotImplementedError do
            cloud_trail_event.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          cloud_trail_event = build(:cloud_trail_event)
          assert_raises ESP::NotImplementedError do
            cloud_trail_event.destroy
          end
        end
      end

      context '.for_alert' do
        should 'throw an error if alert id is not supplied' do
          error = assert_raises ArgumentError do
            ESP::CloudTrailEvent.for_alert
          end
          assert_equal 'You must supply an alert id.', error.message
        end

        should 'call the api' do
          stub_event = stub_request(:get, %r{alerts/5/cloud_trail_events.json*}).to_return(body: json_list(:cloud_trail_event, 2))

          events = ESP::CloudTrailEvent.for_alert(5)

          assert_requested(stub_event)
          assert_equal ESP::CloudTrailEvent, events.resource_class
        end
      end

      context '.find' do
        should 'throw an error if alert_id is not supplied' do
          error = assert_raises ArgumentError do
            ESP::CloudTrailEvent.find(:all, params: { id: 3 })
          end
          assert_equal 'You must supply an alert id.', error.message
        end

        should 'call the show api and return an event if searching by id' do
          stub_event = stub_request(:get, %r{cloud_trail_events/5.json*}).to_return(body: json(:cloud_trail_event))

          event = ESP::CloudTrailEvent.find(5)

          assert_requested(stub_event)
          assert_equal ESP::CloudTrailEvent, event.class
        end

        should 'call the api and return events when alert_id is supplied' do
          stub_event = stub_request(:get, %r{alerts/5/cloud_trail_events.json*}).to_return(body: json_list(:cloud_trail_event, 2))

          events = ESP::CloudTrailEvent.find(:all, params: { alert_id: 5 })

          assert_requested(stub_event)
          assert_equal ESP::CloudTrailEvent, events.resource_class
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '.for_alert' do
          should 'return events for alert id' do
            report = ESP::Report.all.detect { |r| r.status == 'complete' }
            events = ESP::CloudTrailEvent.for_alert(report.alerts.last.id)

            assert_equal ESP::CloudTrailEvent, events.resource_class
          end
        end
      end
    end
  end
end
