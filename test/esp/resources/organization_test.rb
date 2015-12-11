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

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @organization = ESP::Organization.last
          skip "Live DB does not have any sub organizations.  Add a sub organization and run tests again." if @organization.blank?
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '#teams' do
          should 'return teams' do
            teams = @organization.teams

            assert_equal ESP::Team, teams.resource_class
          end
        end

        context '#sub_organizations' do
          should 'return a sub_organization' do
            sub_organizations = @organization.sub_organizations

            assert_equal ESP::SubOrganization, sub_organizations.resource_class
          end
        end

        context '#users' do
          should 'return an array of users' do
            users = @organization.users

            assert_equal ESP::User, users.resource_class
          end
        end

        context '#reports' do
          should 'return an array of reports' do
            reports = @organization.reports

            assert_equal ESP::Report, reports.resource_class
          end
        end

        context '#external_accounts' do
          should 'return an array of external_accounts' do
            external_accounts = @organization.external_accounts

            assert_equal ESP::ExternalAccount, external_accounts.resource_class
          end
        end

        context '#custom_signatures' do
          should 'return an array of custom_signatures' do
            custom_signatures = @organization.custom_signatures

            assert_equal ESP::CustomSignature, custom_signatures.resource_class
          end
        end

        context '.where' do
          should 'return organization objects' do
            organizations = ESP::Organization.where(id_eq: @organization.id)

            assert_equal ESP::Organization, organizations.resource_class
          end
        end

        context '#CRUD' do
          should 'be able to update' do
            @organization.name = @organization.name
            @organization.save

            assert_nothing_raised do
              ESP::Organization.find(@organization.id)
            end
          end
        end
      end
    end
  end
end
