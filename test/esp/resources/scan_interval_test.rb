require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class ScanIntervalTest < ActiveSupport::TestCase
    context ESP::ScanInterval do
      context '#external_account' do
        should 'call the api' do
          scan_interval = build(:scan_interval, external_account_id: 4)
          stub_account = stub_request(:get, %r{external_accounts/#{scan_interval.external_account_id}.json*}).to_return(body: json(:external_account))

          scan_interval.external_account

          assert_requested(stub_account)
        end
      end

      context '#service' do
        should 'call the api' do
          scan_interval = build(:scan_interval, service_id: 4)
          stub_service = stub_request(:get, %r{services/#{scan_interval.service_id}.json*}).to_return(body: json(:service))

          scan_interval.service

          assert_requested(stub_service)
        end
      end

      context '.for_external_account' do
        should 'throw an error if report_id is not supplied' do
          error = assert_raises ArgumentError do
            ESP::ScanInterval.for_external_account
          end
          assert_equal 'You must supply an external account id.', error.message
        end

        should 'call the api and pass params' do
          stub_request(:get, %r{external_accounts/5/scan_intervals.json*}).to_return(body: json_list(:scan_interval, 2))

          intervals = ESP::ScanInterval.for_external_account(5)

          assert_requested(:get, %r{external_accounts/5/scan_intervals.json*})
          assert_equal ESP::ScanInterval, intervals.resource_class
        end
      end

      context '.find' do
        should 'throw an error if external_account_id is not supplied' do
          error = assert_raises ArgumentError do
            ESP::ScanInterval.find(:all, params: { id: 3 })
          end
          assert_equal 'You must supply an external account id.', error.message
        end

        should 'call the show api and return an alert if searching by id' do
          stub_scan_interval = stub_request(:get, %r{scan_intervals/5.json*}).to_return(body: json(:scan_interval))

          scan_interval = ESP::ScanInterval.find(5)

          assert_requested(stub_scan_interval)
          assert_equal ESP::ScanInterval, scan_interval.class
        end

        should 'call the api and return scan_intervals when external_account_id is supplied' do
          stub_scan_interval = stub_request(:get, %r{external_accounts/5/scan_intervals.json*}).to_return(body: json_list(:scan_interval, 2))

          scan_interval = ESP::ScanInterval.find(:all, params: { external_account_id: 5 })

          assert_requested(stub_scan_interval)
          assert_equal ESP::ScanInterval, scan_interval.resource_class
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @external_account = ESP::ExternalAccount.last
          @service = ESP::Service.last
          skip "Live DB does not have any external_accounts.  Add an external_account and run tests again." if @external_account.blank?
          skip "Live DB does not have any services.  Add an service and run tests again." if @service.blank?
        end

        teardown do
          # destroy record incase of failure
          @scan_interval.destroy rescue nil # rubocop:disable Style/RescueModifier
          WebMock.disable_net_connect!
        end

        context '#CRUD' do
          should 'be able to create, update and destroy' do
            @scan_interval = ESP::ScanInterval.new(interval: 15, service_id: @service.id, external_account_id: @external_account.id)

            # Create
            assert_predicate @scan_interval, :new?
            @scan_interval.save
            refute_predicate @scan_interval, :new?

            # Update
            @scan_interval.interval = 30
            @scan_interval.save
            assert_nothing_raised do
              ESP::ScanInterval.find(@scan_interval.id.to_i)
            end

            # Service Relationship
            service = @scan_interval.service
            assert_equal service.id, @service.id

            # External Account Relationship
            external_account = @scan_interval.external_account
            assert_equal external_account.id, @external_account.id

            # Destroy
            @scan_interval.destroy

            assert_raises ActiveResource::ResourceNotFound do
              ESP::ScanInterval.find(@scan_interval.id.to_i)
            end
          end
        end
      end
    end
  end
end
