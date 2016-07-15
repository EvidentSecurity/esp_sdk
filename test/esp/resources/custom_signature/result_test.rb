require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module ESP
  class CustomSignature
    class ResultTest < ActiveSupport::TestCase
      context ESP::CustomSignature::Result do
        context '#definition' do
          should 'call the api' do
            result = build(:result, definition_id: 4)
            stubbed_definition = stub_request(:get, %r{custom_signature_definitions/#{result.definition_id}.json*}).to_return(body: json(:definition))

            result.definition

            assert_requested(stubbed_definition)
          end
        end

        context '#region' do
          should 'call the api' do
            result = build(:result, region_id: 4)
            stubbed_region = stub_request(:get, %r{regions/#{result.region_id}.json*}).to_return(body: json(:region))

            result.region

            assert_requested(stubbed_region)
          end
        end

        context '#external_account' do
          should 'call the api' do
            result = build(:result, external_account_id: 4)
            stubbed_external_account = stub_request(:get, %r{external_accounts/#{result.external_account_id}.json*}).to_return(body: json(:external_account))

            result.external_account

            assert_requested(stubbed_external_account)
          end
        end

        context '#alerts' do
          should 'call the api' do
            result = build(:result)
            stub_request(:get, %r{custom_signature_results/#{result.id}/alerts.json}).to_return(body: json_list(:result_alert, 2))

            result.alerts

            assert_requested(:get, %r{custom_signature_results/#{result.id}/alerts.json})
          end
        end

        context 'activate' do
          should 'call the api' do
            definition = build(:definition)
            stubbed_defintion = stub_request(:patch, %r{custom_signature_definitions/#{definition.id}/activate.json}).to_return(body: json(:definition))

            definition.activate

            assert_requested stubbed_defintion
          end
        end

        context 'archive' do
          should 'call the api' do
            definition = build(:definition)
            stubbed_defintion = stub_request(:patch, %r{custom_signature_definitions/#{definition.id}/archive.json}).to_return(body: json(:definition))

            definition.archive

            assert_requested stubbed_defintion
          end
        end

        context '#update' do
          should 'raise ESP::NotImplementedError' do
            assert_raises ESP::NotImplementedError do
              ESP::CustomSignature::Result::Alert.new.update
            end
          end
        end

        context '#destroy' do
          should 'raise ESP::NotImplementedError' do
            assert_raises ESP::NotImplementedError do
              ESP::CustomSignature::Result::Alert.new.destroy
            end
          end
        end
      end
    end
  end
end
