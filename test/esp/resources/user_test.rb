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
          stub_org = stub_request(:get, %r{organizations/#{u.organization_id}.json*}).to_return(body: json(:organization))

          u.organization

          assert_requested(stub_org)
        end
      end

      context '#sub_organizations' do
        should 'call the api' do
          u = build(:user, sub_organization_ids: [1, 2])
          stub_request(:put, /sub_organizations.json*/).to_return(body: json_list(:sub_organization, 2))

          u.sub_organizations

          assert_requested(:put, /sub_organizations.json*/) do |req|
            body = JSON.parse(req.body)
            assert_equal [1, 2], body["filter"]["id_in"]
          end
        end

        should 'not call the api if it was returned in an include' do
          stub_request(:get, %r{users/1.json*}).to_return(body: json(:user, :with_include))
          user = ESP::User.find(1)
          stub_request(:put, /sub_organizations.json*/)

          assert_not_nil user.attributes['sub_organizations']

          user.sub_organizations

          assert_not_requested(:put, /sub_organizations.json*/)
        end
      end

      context '#teams' do
        should 'call the api' do
          u = build(:user, team_ids: [1, 2])
          stub_request(:put, /teams.json*/).to_return(body: json_list(:team, 2))

          u.teams

          assert_requested(:put, /teams.json*/) do |req|
            body = JSON.parse(req.body)
            assert_equal [1, 2], body["filter"]["id_in"]
          end
        end

        should 'not call the api if it was returned in an include' do
          stub_request(:get, %r{users/1.json*}).to_return(body: json(:user, :with_include))
          user = ESP::User.find(1)
          stub_request(:put, /teams.json*/)

          assert_not_nil user.attributes['teams']

          user.teams

          assert_not_requested(:put, /teams.json*/)
        end
      end
    end
  end
end
