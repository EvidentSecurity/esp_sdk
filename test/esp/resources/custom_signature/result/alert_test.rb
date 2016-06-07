require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

module ESP
  class CustomSignature
    class Result
      class AlertTest < ActiveSupport::TestCase
        context ESP::CustomSignature::Result::Alert do
          context '#region' do
            should 'call the api' do
              alert = build(:result_alert, region_id: 4)
              stubbed_region = stub_request(:get, %r{regions/#{alert.region_id}.json*}).to_return(body: json(:region))

              alert.region

              assert_requested(stubbed_region)
            end
          end

          context '#external_account' do
            should 'call the api' do
              alert = build(:result_alert, external_account_id: 4)
              stubbed_external_account = stub_request(:get, %r{external_accounts/#{alert.external_account_id}.json*}).to_return(body: json(:external_account))

              alert.external_account

              assert_requested(stubbed_external_account)
            end
          end

          context '#custom_signature' do
            should 'call the api' do
              alert = build(:result_alert, custom_signature_id: 4)
              stubbed_custom_signature = stub_request(:get, %r{custom_signatures/#{alert.custom_signature_id}.json*}).to_return(body: json(:custom_signature))

              alert.custom_signature

              assert_requested(stubbed_custom_signature)
            end
          end
        end
      end
    end
  end
end
