require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class AlertTest < ESP::Integration::TestCase
    context ESP::Alert do
      context 'live calls' do
        setup do
          @report = ESP::Report.all.detect { |r| r.status == 'complete' }
          skip "Live DB does not have any reports.  Add a report and run tests again." if @report.blank?
          @alert = @report.alerts.last
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
            @alert.attributes['signature_id'] ||= 1
            signature = @alert.signature

            assert_equal ESP::Signature, signature.class
            assert_equal @alert.signature_id, signature.id
          end
        end

        context '#custom_signature' do
          should 'return a custom_signature' do
            @alert.attributes['custom_signature_id'] ||= 1
            custom_signature = @alert.custom_signature

            assert_equal ESP::CustomSignature, custom_signature.class
            assert_equal @alert.custom_signature_id.to_s, custom_signature.id.to_s
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
