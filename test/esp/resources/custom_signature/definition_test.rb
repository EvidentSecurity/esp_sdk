require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module ESP
  class CustomSignature
    class DefinitionTest < ActiveSupport::TestCase
      context ESP::CustomSignature::Definition do
        context '#custom_signature' do
          should 'call the api' do
            definition = build(:definition, custom_signature_id: 4)
            stubbed_custom_signature = stub_request(:get, %r{custom_signatures/#{definition.custom_signature_id}.json*}).to_return(body: json(:custom_signature))

            definition.custom_signature

            assert_requested(stubbed_custom_signature)
          end
        end

        context '#results' do
          should 'call the api' do
            definition = build(:definition)
            stub_request(:get, /custom_signature_results.json*/).to_return(body: json_list(:result, 2))

            definition.results

            assert_requested(:get, /custom_signature_results.json*/) do |req|
              assert_equal "filter[definition_id_eq]=#{definition.id}", URI.unescape(req.uri.query)
            end
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
      end
    end
  end
end
