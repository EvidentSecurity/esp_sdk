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
          alert = build(:alert)
          assert_raises ESP::NotImplementedError do
            alert.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          alert = build(:alert)
          assert_raises ESP::NotImplementedError do
            alert.destroy
          end
        end
      end

      context '#external_account' do
        should 'call the api' do
          alert = build(:alert, external_account_id: 3)
          stubbed_external_account = stub_request(:get, %r{external_accounts/#{alert.external_account_id}.json*}).to_return(body: json(:external_account))

          alert.external_account

          assert_requested(stubbed_external_account)
        end
      end

      context '#region' do
        should 'call the api' do
          alert = build(:alert, region_id: 3)
          stubbed_region = stub_request(:get, %r{regions/#{alert.region_id}.json*}).to_return(body: json(:region))

          alert.region

          assert_requested(stubbed_region)
        end
      end

      context '#signature' do
        should 'call the api' do
          alert = build(:alert, signature_id: 3)
          stubbed_signature = stub_request(:get, %r{signatures/#{alert.signature_id}.json*}).to_return(body: json(:signature))

          alert.signature

          assert_requested(stubbed_signature)
        end
      end

      context '#custom_signature' do
        should 'call the api' do
          alert = build(:alert, custom_signature_id: 3)
          stubbed_custom_signature = stub_request(:get, %r{custom_signatures/#{alert.custom_signature_id}.json*}).to_return(body: json(:custom_signature))

          alert.custom_signature

          assert_requested(stubbed_custom_signature)
        end
      end

      context '#suppression' do
        should 'call the api' do
          alert = build(:alert, suppression_id: 3)
          stubbed_suppression = stub_request(:get, %r{suppressions/#{alert.suppression_id}.json*}).to_return(body: json(:suppression))

          alert.suppression

          assert_requested(stubbed_suppression)
        end
      end

      context '#cloud_trail_events' do
        should 'call the api for the alert' do
          alert = build(:alert)
          stubbed_events = stub_request(:get, %r{alerts/#{alert.id}/cloud_trail_events.json*}).to_return(body: json_list(:cloud_trail_event, 2))

          alert.cloud_trail_events

          assert_requested(stubbed_events)
        end
      end

      context '#tags' do
        should 'call the api for the alert' do
          alert = build(:alert)
          stubbed_tags = stub_request(:get, %r{alerts/#{alert.id}/tags.json*}).to_return(body: json_list(:tag, 2))

          alert.tags

          assert_requested(stubbed_tags)
        end
      end

      context '.where' do
        should 'throw an error if report_id is not supplied' do
          error = assert_raises ArgumentError do
            ESP::Alert.where(status: 'complete')
          end
          assert_equal 'You must supply a report id.', error.message
        end

        should 'call the api and return alerts when report_id is supplied' do
          stub_alert = stub_request(:put, %r{reports/5/alerts.json*}).to_return(body: json_list(:alert, 2))

          alert = ESP::Alert.where(report_id: 5)

          assert_requested(stub_alert)
          assert_equal ESP::Alert, alert.resource_class
        end
      end

      context '.find' do
        should 'throw an error if report_id is not supplied' do
          error = assert_raises ArgumentError do
            ESP::Alert.find(:all, params: { id: 3 })
          end
          assert_equal 'You must supply a report id.', error.message
        end

        should 'call the show api and return an alert if searching by id' do
          stub_alert = stub_request(:get, %r{alerts/5.json*}).to_return(body: json(:alert))

          alert = ESP::Alert.find(5)

          assert_requested(stub_alert)
          assert_equal ESP::Alert, alert.class
        end

        should 'call the api and return alerts when report_id is supplied' do
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
          @report = ESP::Report.all.detect { |r| r.status == 'complete' }
          skip "Live DB does not have any reports.  Add a report and run tests again." if @report.blank?
          @alert = @report.alerts.last
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '#external_account' do
          should 'return an external_account' do
            external_account = @alert.external_account

            assert_equal ESP::ExternalAccount, external_account.class
            assert_equal @alert.external_account_id, external_account.id
          end
        end

        context '#region' do
          should 'return a region' do
            region = @alert.region

            assert_equal ESP::Region, region.class
            assert_equal @alert.region_id, region.id
          end
        end

        context '#signature' do
          should 'return a signature' do
            signature = @alert.signature

            assert_equal ESP::Signature, signature.class
            assert_equal @alert.signature_id, signature.id
          end
        end

        context '#custom_signature' do
          should 'return a custom_signature' do
            assert_nothing_raised do
              @alert.attributes['custom_signature_id'] ||= 1
              @alert.custom_signature
            end
          end
        end

        context '#suppression' do
          should 'return a suppression' do
            assert_nothing_raised do
              @alert.attributes['suppression_id'] ||= 1
              @alert.suppression
            end
          end
        end

        context '#cloud_trail_events' do
          should 'return cloud_trail_events' do
            assert_nothing_raised do
              @alert.cloud_trail_events
            end
          end
        end

        context '#tags' do
          should 'return tags' do
            assert_nothing_raised do
              @alert.tags
            end
          end
        end

        context '.find' do
          should 'return an alert by id' do
            alert = ESP::Alert.find(@alert.id.to_i)

            assert_equal ESP::Alert, alert.class
            assert_equal @alert.id, alert.id
          end
        end

        context '.where' do
          should 'return alert objects' do
            alerts = ESP::Alert.where(report_id: @report.id, id_eq: @alert.id)

            assert_equal ESP::Alert, alerts.resource_class
            assert_equal @alert.id, alerts.first.id
          end
        end
      end
    end
  end
end
