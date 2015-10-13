require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class ResourceTest < ActiveSupport::TestCase
    context ESP::Resource do
      context 'with ESP::Team' do
        should 'set the Content-Type to application/vnd.api+json' do
          stub_request(:get, %r{teams/3.json*}).to_return(body: json(:team))

          ESP::Team.find(3)

          assert_requested(:get, %r{teams/3.json*}) do |req|
            assert_equal ActiveResource::Formats::JsonAPIFormat.mime_type, req.headers['Content-Type']
          end
        end

        should 'set the HMAC needed Authorization header' do
          ESP.access_key_id ||= ApiAuth.generate_secret_key
          ESP.secret_access_key ||= ApiAuth.generate_secret_key
          ESP::Team.hmac_access_id = ESP.access_key_id
          ESP::Team.hmac_secret_key = ESP.secret_access_key
          stub_request(:get, %r{teams/3.json*}).to_return(body: json(:team))

          ESP::Team.find(3)

          assert_requested(:get, %r{teams/3.json*}) do |req|
            # Remove non word chars to prevent regex matching errors.
            assert_match(/APIAuth#{ESP.access_key_id.gsub(/\W/, '')}/, req.headers['Authorization'].gsub(/\W/, ''))
          end
        end

        context '.where' do
          should 'not be implemented yet' do
            assert_raise ESP::NotImplementedError do
              ESP::Team.where(id: 1)
            end
          end
        end

        context '#serializable_hash' do
          should 'format per json api standard' do
            t = build(:team)

            h = t.serializable_hash

            assert_equal t.id, h['data']['id']
            assert_equal 'teams', h['data']['type']
            assert_equal t.name, h['data']['attributes']['name']
          end

          should 'should not include the id if it is not present' do
            t = build(:team, id: nil)

            h = t.serializable_hash

            assert_equal false, h['data'].key?('id')
          end
        end

        context '#find' do
          should 'call the show method when finding by single id' do
            stub_request(:get, %r{teams/3.json*}).to_return(body: json(:team))

            ESP::Team.find(3)

            assert_requested(:get, %r{teams/3.json*})
          end

          should 'build query string inside filter param and ad _q when single value' do
            stub_request(:get, /teams.json*/).to_return(body: json_list(:team, 2))

            ESP::Team.find(:all, params: { id: 3 })

            assert_requested(:get, /teams.json*/) do |req|
              query = Rack::Utils.parse_nested_query(CGI.unescape(req.uri.query))
              assert_equal true, query.key?('filter')
              assert_equal true, query['filter'].key?('id_eq')
              assert_equal '3', query['filter']['id_eq']
            end
          end

          should 'build query string inside filter param and ad _in when multiple values' do
            stub_request(:get, /teams.json*/).to_return(body: json_list(:team, 2))

            ESP::Team.find(:all, params: { id: [3, 4] })

            assert_requested(:get, /teams.json*/) do |req|
              query = Rack::Utils.parse_nested_query(CGI.unescape(req.uri.query))
              assert_equal true, query.key?('filter')
              assert_equal true, query['filter'].key?('id_in')
              assert_equal({ "0" => "3", "1" => "4" }, query['filter']['id_in'])
            end
          end
        end

        should 'not put page parameter inside filter parameter' do
          stub_request(:get, /teams.json*/).to_return(body: json_list(:team, 2))

          ESP::Team.find(:all, params: { id: 3, page: { number: 2, size: 3 } })

          assert_requested(:get, /teams.json*/) do |req|
            query = Rack::Utils.parse_nested_query(CGI.unescape(req.uri.query))
            assert_equal true, query.key?('filter')
            assert_equal '2', query['page']['number']
          end
        end

        should 'not ransackize the filter parameter if it is passed' do
          stub_request(:get, /teams.json*/).to_return(body: json_list(:team, 2))

          ESP::Team.find(:all, params: { filter: { id_eq: 3 }, page: { number: 2, size: 3 } })

          assert_requested(:get, /teams.json*/) do |req|
            query = Rack::Utils.parse_nested_query(CGI.unescape(req.uri.query))
            assert_equal true, query.key?('filter')
            assert_equal true, query['filter'].key?('id_eq')
          end
        end

        should 'add the from attribute to PaginatedCollection objects when from is supplied' do
          stub_request(:get, /teams.json*/).to_return(body: json_list(:team, 2))

          teams = ESP::Team.find(:all, from: "#{Team.prefix}teams.json", params: { filter: { id_eq: 3 }, page: { number: 2, size: 3 } })

          assert_equal '/api/v2/teams.json', teams.from
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @team = ESP::Team.last
          skip "Live DB does not have any teams.  Add a team and run tests again." if @team.blank?
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context 'with ESP::Team' do
          should 'find a team' do
            t = ESP::Team.find(@team.id)

            assert_equal ESP::Team, t.class
            assert_equal @team.id, t.id
          end

          should 'find teams' do
            t = ESP::Team.find(:all, params: { id: @team.id })

            assert_equal ESP::Team, t.resource_class
            assert_equal 1, t.count
          end
        end
      end
    end
  end
end
