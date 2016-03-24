require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class ScanIntervalTest < ESP::Integration::TestCase
    context ESP::ScanInterval do
      context 'live calls' do
        setup do
          @external_account = ESP::ExternalAccount.last
          @service = ESP::Service.last
          fail "Live DB does not have any external_accounts.  Add an external_account and run tests again." if @external_account.blank?
          fail "Live DB does not have any services.  Add an service and run tests again." if @service.blank?
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
