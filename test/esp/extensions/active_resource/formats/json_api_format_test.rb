require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

module ActiveResource
  module Formats
    class JsonAPIFormatTest < ActiveSupport::TestCase
      context ActiveResource::Formats::JsonAPIFormat do
        context '# decode' do
          context 'with ESP::Suppression' do
            should 'parse nested objects correctly' do
              suppression = build(:suppression)
              stub_request(:get, /suppressions*/).to_return(body: json_list(:suppression, 1))
              parsed_suppression = ESP::Suppression.last # decode is called when parsing the response

              assert_equal suppression.attributes['configuration']['regions'].first['attributes']['code'], parsed_suppression.configuration.regions.first.code
              assert_equal suppression.attributes['configuration']['external_accounts'].first['attributes']['name'], parsed_suppression.configuration.external_accounts.first.name
              assert_equal suppression.attributes['configuration']['external_accounts'].first['relationships']['organization']['data']['id'], parsed_suppression.configuration.external_accounts.first.organization_id
            end
          end

          context 'with ESP::Alert' do
            should 'merge included objects' do
              json = json_list(:alert, 1)
              parsed_json = JSON.parse(json)
              stub_request(:get, %r{reports/1/alerts.json*}).to_return(body: json)

              alert = ESP::Alert.for_report(1).first

              assert_equal parsed_json['included'].detect { |e| e['type'] == 'external_accounts' }['id'], alert.external_account.id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'regions' }['id'], alert.region.id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'signatures' }['id'], alert.signature.id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'cloud_trail_events' }['id'], alert.cloud_trail_events.first.id
            end

            should 'assign foreign keys' do
              json = json_list(:alert, 1)
              parsed_json = JSON.parse(json)
              stub_request(:get, %r{reports/1/alerts.json*}).to_return(body: json)

              alert = ESP::Alert.for_report(1).first

              assert_equal parsed_json['included'].detect { |e| e['type'] == 'external_accounts' }['id'], alert.external_account_id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'regions' }['id'], alert.region_id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'signatures' }['id'], alert.signature_id
              assert_contains alert.cloud_trail_event_ids, parsed_json['included'].detect { |e| e['type'] == 'cloud_trail_events' }['id']

              # nested objects too
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'external_accounts' }['relationships']['organization']['data']['id'], alert.external_account.organization_id
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
        end
      end

      context ActiveResource::ConnectionError do
        context "with ESP::Team" do
          context '.initialize' do
            should 'parse the response and return a descriptive error message' do
              error_response = json(:error, :active_record)
              response = Net::HTTPBadRequest.new('1.0', '200', '')
              response.expects(:body).returns(error_response).at_least_once

              error = ActiveResource::BadRequest.new(response)

              assert_equal "Failed.  Response code = 200.  Response message = Name can't be blank Description can't be blank.", error.message
            end

            should 'have the generic message if there is not reponse body' do
              error = ActiveResource::BadRequest.new('oh no')

              assert_equal "Failed.", error.message
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

          context "with ESP::Team" do
            context '.initialize' do
              should 'parse the error and return a descriptive error message' do
                error = assert_raises ActiveResource::BadRequest do
                  ESP::Team.create
                end
                assert_equal 'Failed.  Response code = 400.  Response message = param is missing or the value is empty: attributes.', error.message
              end
            end
          end
        end
      end
    end
  end
end
