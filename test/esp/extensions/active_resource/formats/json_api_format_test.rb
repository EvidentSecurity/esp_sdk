require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

module ActiveResource
  module Formats
    class JsonAPIFormatTest < ActiveSupport::TestCase
      context ActiveResource::Formats::JsonAPIFormat do
        context '# decode' do
          context 'with ESP::Suppression' do
            should 'parse nested objects correctly' do
              json        = json(:dashboard)
              parsed_json = JSON.parse(json)
              stub_request(:get, %r{dashboard/recent*}).to_return(body: json_list(:dashboard, 1))

              dashboard = ESP::Dashboard.recent

              assert_equal parsed_json['included'].first['attributes']['stat_signatures'].first['signature']['name'], dashboard.first.stat.stat_signatures.first.signature.name
            end
          end

          context 'with ESP::Alert' do
            should 'merge nested included objects' do
              json        = json(:alert)
              parsed_json = JSON.parse(json)
              stub_request(:get, %r{alerts/1.json*}).to_return(body: json)

              alert = ESP::Alert.find(1, include: 'external_account.team.organization,region,signature,cloud_trail_events')

              assert_equal parsed_json['included'].detect { |e| e['type'] == 'external_accounts' }['id'], alert.external_account.id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'organizations' }['id'], alert.external_account.organization.id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'teams' }['id'], alert.external_account.team.id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'organizations' }['id'], alert.external_account.team.organization.id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'regions' }['id'], alert.region.id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'signatures' }['id'], alert.signature.id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'cloud_trail_events' }['id'], alert.cloud_trail_events.first.id
            end

            should 'assign foreign keys' do
              json        = json_list(:alert, 1)
              parsed_json = JSON.parse(json)
              stub_request(:put, %r{reports/1/alerts.json*}).to_return(body: json)

              alert = ESP::Alert.where(report_id: 1).first

              assert_equal parsed_json['included'].detect { |e| e['type'] == 'external_accounts' }['id'], alert.external_account_id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'regions' }['id'], alert.region_id
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'signatures' }['id'], alert.signature_id
              assert_contains alert.cloud_trail_event_ids, parsed_json['included'].detect { |e| e['type'] == 'cloud_trail_events' }['id']

              # nested objects too
              assert_equal parsed_json['included'].detect { |e| e['type'] == 'external_accounts' }['relationships']['organization']['data']['id'], alert.external_account.organization_id
            end

            should 'not error with included nulls' do
              manufactured_hash = JSON.parse(json_list(:alert, 1))
              manufactured_hash['included'] << nil
              stub_request(:put, %r{reports/1/alerts.json*}).to_return(body: manufactured_hash.to_json)

              ESP::Alert.where(report_id: 1).first
            end
          end
        end
      end

      context ActiveResource::ConnectionError do
        context "with ESP::Team" do
          context '.initialize' do
            should 'parse the response and return a descriptive error message' do
              error_response = json(:error, :active_record)
              response       = Net::HTTPBadRequest.new('1.0', '200', '')
              response.expects(:body).returns(error_response).at_least_once

              error = ActiveResource::BadRequest.new(response)

              assert_equal "Failed.  Response code = 200.  Response message = Name can't be blank Name is invalid Description can't be blank.", error.message
            end

            should 'have the generic message if there is not reponse body' do
              error = ActiveResource::BadRequest.new('oh no')

              assert_equal "Failed.", error.message
            end
          end
        end
      end
    end
  end
end
