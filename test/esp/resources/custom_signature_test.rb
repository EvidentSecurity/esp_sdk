require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class CustomSignatureTest < ActiveSupport::TestCase
    context ESP::CustomSignature do
      context '#organization' do
        should 'call the api' do
          custom_signature = build(:custom_signature, organization_id: 4)
          stubbed_organization = stub_request(:get, %r{organizations/#{custom_signature.organization_id}.json*}).to_return(body: json(:organization))

          custom_signature.organization

          assert_requested(stubbed_organization)
        end
      end

      context '#teams' do
        should 'call the api' do
          custom_signature = build(:custom_signature, team_id: 1)
          stub_request(:put, /teams.json*/).to_return(body: json_list(:team, 2))

          custom_signature.teams

          assert_requested(:put, /teams.json*/) do |req|
            body = JSON.parse(req.body)
            assert_equal custom_signature.id, body['filter']['custom_signatures_id_eq']
          end
        end
      end

      context '#definitions' do
        should 'call the api' do
          custom_signature = build(:custom_signature, team_id: 1)
          stub_request(:get, /custom_signature_definitions.json*/).to_return(body: json_list(:definition, 2))

          custom_signature.definitions

          assert_requested(:get, /custom_signature_definitions.json*/) do |req|
            assert_equal "filter[custom_signature_id_eq]=#{custom_signature.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#suppress' do
        should 'call the api' do
          stub_request(:post, %r{suppressions/signatures.json*}).to_return(body: json(:suppression_signature))
          custom_signature = build(:custom_signature)

          suppression = custom_signature.suppress(regions: ['us_east_1'], external_account_ids: [5], reason: 'because')

          assert_requested(:post, %r{suppressions/signatures.json*}) do |req|
            body = JSON.parse(req.body)
            assert_equal 'because', body['data']['attributes']['reason']
            assert_equal [custom_signature.id], body['data']['attributes']['custom_signature_ids']
            assert_equal ['us_east_1'], body['data']['attributes']['regions']
            assert_equal [5], body['data']['attributes']['external_account_ids']
          end
          assert_equal ESP::Suppression::Signature, suppression.class
        end
      end
    end
  end
end
