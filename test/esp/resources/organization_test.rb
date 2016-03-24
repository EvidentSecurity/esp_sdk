require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class OrganizationTest < ActiveSupport::TestCase
    context ESP::Organization do
      context '#create' do
        should 'not be implemented' do
          organization = build(:organization)
          assert_raises ESP::NotImplementedError do
            organization.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          organization = build(:organization)
          assert_raises ESP::NotImplementedError do
            organization.destroy
          end
        end
      end

      context '#teams' do
        should 'call the api' do
          organization = build(:organization)
          stub_request(:get, /teams.json*/).to_return(body: json_list(:organization, 2))

          organization.teams

          assert_requested(:get, /teams.json*/) do |req|
            assert_equal "filter[organization_id_eq]=#{organization.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#sub_organizations' do
        should 'call the api' do
          organization = build(:organization)
          stub_request(:get, /sub_organizations.json*/).to_return(body: json_list(:sub_organization, 2))

          organization.sub_organizations

          assert_requested(:get, /sub_organizations.json*/) do |req|
            assert_equal "filter[organization_id_eq]=#{organization.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#users' do
        should 'call the api' do
          organization = build(:organization)
          stub_request(:get, /users.json*/).to_return(body: json_list(:user, 2))

          organization.users

          assert_requested(:get, /users.json*/) do |req|
            assert_equal "filter[organization_id_eq]=#{organization.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#reports' do
        should 'call the api' do
          organization = build(:organization)
          stub_request(:get, /reports.json*/).to_return(body: json_list(:report, 2))

          organization.reports

          assert_requested(:get, /reports.json*/) do |req|
            assert_equal "filter[organization_id_eq]=#{organization.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#external_accounts' do
        should 'call the api' do
          organization = build(:organization)
          stub_request(:get, /external_accounts.json*/).to_return(body: json_list(:external_account, 2))

          organization.external_accounts

          assert_requested(:get, /external_accounts.json*/) do |req|
            assert_equal "filter[organization_id_eq]=#{organization.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#custom_signatures' do
        should 'call the api' do
          organization = build(:organization)
          stub_request(:get, /custom_signatures.json*/).to_return(body: json_list(:custom_signature, 2))

          organization.custom_signatures

          assert_requested(:get, /custom_signatures.json*/) do |req|
            assert_equal "filter[organization_id_eq]=#{organization.id}", URI.unescape(req.uri.query)
          end
        end
      end
    end
  end
end
