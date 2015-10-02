require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class AlertTest < ActiveSupport::TestCase
    context ESP::Alert do
      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Alert.create(name: 'test')
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

      context '#cloud_trail_events' do
        should 'call the api for the report and the passed in params' do
          alert = build(:alert)
          stubbed_events = stub_request(:get, %r{alerts/#{alert.id}/cloud_trail_events.json*}).to_return(body: json_list(:cloud_trail_event, 2))

          alert.cloud_trail_events

          assert_requested(stubbed_events)
        end
      end

      context '.for_report' do
        should 'throw an error if report_id is not supplied' do
          error = assert_raises ArgumentError do
            ESP::Alert.for_report
          end
          assert_equal 'You must supply a report id.', error.message
        end

        should 'call the api and pass params' do
          stub_request(:get, %r{reports/5/alerts.json*}).to_return(body: json_list(:alert, 2))

          alerts = ESP::Alert.for_report(5, status: 'pass')

          assert_requested(:get, %r{reports/5/alerts.json*}) do |req|
            assert_equal "filter[status]=pass", URI.unescape(req.uri.query)
          end
          assert_equal ESP::Alert, alerts.resource_class
        end
      end

      context '.find' do
        should 'call the show api and return an alert if searching by id' do
          stub_alert = stub_request(:get, %r{alerts/5.json*}).to_return(body: json(:alert))

          alert = ESP::Alert.find(5)

          assert_requested(stub_alert)
          assert_equal ESP::Alert, alert.class
        end

        should 'call the api and return alerts with report_id is supplied' do
          stub_alert = stub_request(:get, %r{reports/5/alerts.json*}).to_return(body: json_list(:alert, 2))

          alert = ESP::Alert.find(:all, params: { report_id: 5 })

          assert_requested(stub_alert)
          assert_equal ESP::Alert, alert.resource_class
        end
      end

      context '#suppress_signature' do
        should 'throw an error if reason is not supplied' do
          alert = build(:alert)

          error = assert_raises ArgumentError do
            alert.suppress_signature
          end
          assert_equal 'You must specify the reason.', error.message
        end

        should 'call Suppression::Signature.create' do
          alert = build(:alert)
          Suppression::Signature.stubs(:create)

          alert.suppress_signature('the reason')

          assert_received(Suppression::Signature, :create) do |expects|
            expects.with do |params|
              assert_equal alert.id, params[:alert_id]
              assert_equal 'the reason', params[:reason]
            end
          end
        end
      end

      context '#suppress_region' do
        should 'throw an error if reason is not supplied' do
          alert = build(:alert)

          error = assert_raises ArgumentError do
            alert.suppress_region
          end
          assert_equal 'You must specify the reason.', error.message
        end

        should 'call Suppression::Region.create' do
          alert = build(:alert)
          Suppression::Region.stubs(:create)

          alert.suppress_region('the reason')

          assert_received(Suppression::Region, :create) do |expects|
            expects.with do |params|
              assert_equal alert.id, params[:alert_id]
              assert_equal 'the reason', params[:reason]
            end
          end
        end
      end

      context '#suppress_unique_identifier' do
        should 'throw an error if reason is not supplied' do
          alert = build(:alert)

          error = assert_raises ArgumentError do
            alert.suppress_unique_identifier
          end
          assert_equal 'You must specify the reason.', error.message
        end

        should 'call Suppression::UniqueIdentifier.create' do
          alert = build(:alert)
          Suppression::UniqueIdentifier.stubs(:create)

          alert.suppress_unique_identifier('the reason')

          assert_received(Suppression::UniqueIdentifier, :create) do |expects|
            expects.with do |params|
              assert_equal alert.id, params[:alert_id]
              assert_equal 'the reason', params[:reason]
            end
          end
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
          should 'return events for report id' do
            report = ESP::Report.last
            alerts = ESP::Alert.for_report(report.id)

            assert_equal ESP::Alert, alerts.resource_class
          end
        end

        context '.find' do
          should 'return an alert by id' do
            report = ESP::Report.last
            alert_id = report.alerts.last.id
            alert = ESP::Alert.find(alert_id.to_i)

            assert_equal ESP::Alert, alert.class
            assert_equal alert_id, alert.id
          end
        end
      end
    end
  end
end
