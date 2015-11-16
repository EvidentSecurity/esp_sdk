require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class UserTest < ActiveSupport::TestCase
    context ESP::User do
      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::User.create(name: 'test')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          u = build(:user)
          assert_raises ESP::NotImplementedError do
            u.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          u = build(:user)
          assert_raises ESP::NotImplementedError do
            u.destroy
          end
        end
      end

      context '#organization' do
        should 'call the api' do
          u = build(:user, organization_id: 1)
          stub_org = stub_request(:get, %r{organizations/#{u.organization_id}.json_api*}).to_return(body: json(:organization))

          u.organization

          assert_requested(stub_org)
        end
      end

      context '#sub_organizations' do
        should 'call the api' do
          u = build(:user, sub_organization_ids: [1, 2])
          stub_request(:get, /sub_organizations.json_api*/).to_return(body: json_list(:sub_organization, 2))

          u.sub_organizations

          assert_requested(:get, /sub_organizations.json_api*/) do |req|
            assert_equal "filter[id_in][0]=#{u.sub_organization_ids.first}&filter[id_in][1]=#{u.sub_organization_ids.second}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#teams' do
        should 'call the api' do
          u = build(:user, team_ids: [1, 2])
          stub_request(:get, /teams.json_api*/).to_return(body: json_list(:team, 2))

          u.teams

          assert_requested(:get, /teams.json_api*/) do |req|
            assert_equal "filter[id_in][0]=#{u.team_ids.first}&filter[id_in][1]=#{u.team_ids.second}", URI.unescape(req.uri.query)
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

        context '#organization' do
          should 'return an organization' do
            u = ESP::User.last

            org = u.organization

            assert_equal u.organization_id, org.id
          end
        end

        context '#sub_organizations' do
          should 'return an array of sub_organizations' do
            u = ESP::User.last

            sub_orgs = u.sub_organizations

            assert_equal u.sub_organization_ids.count, sub_orgs.count
            assert_equal u.sub_organization_ids, sub_orgs.map(&:id)
          end
        end

        context '#teams' do
          should 'return an array of teams' do
            u = ESP::User.last

            teams = u.teams

            assert_equal u.team_ids.count, teams.count
            assert_equal u.team_ids.sort, teams.map(&:id).sort
          end
        end
      end
    end
  end
end
