require_relative '../test_helper'
require_relative '../../lib/esp/aws_clients'
require_relative '../../lib/esp/external_account_creator'

module ESP
  class ExternalAccountCreatorTest < ActiveSupport::TestCase
    context ESP::ExternalAccountCreator do
      context "#create" do
        setup do
          @external_account_creator = ExternalAccountCreator.new

          @external_account_creator.aws.stubs(:owner_id).returns('012345678912')

          role = mock
          role.stubs(:arn).returns('arn')
          aws_role_object = mock
          aws_role_object.stubs(:role).returns(role)
          @external_account_creator.aws.stubs(:create_and_attach_role!).returns(aws_role_object)

          @team_stub             = stub_request(:put, /teams.json*/).to_return(body: json_list(:team, 1))
          @sub_organization_stub = stub_request(:put, /sub_organizations.json*/).to_return(body: json_list(:sub_organization, 1))

          @external_account_creator.stubs(:sleep).returns(0)

          @external_account_stub = stub_request(:post, /external_accounts.json*/).to_return(body: json(:external_account))
        end

        should "fail if aws is not valid" do
          @external_account_creator.aws.unstub(:owner_id)
          @external_account_creator.aws.stubs(:owner_id).returns('abc')

          exception = assert_raises AddExternalAccountError do
            @external_account_creator.create
          end

          assert_match(/wrong length/, exception.message)
          assert_equal AddExternalAccountError::EXIT_CODES['12 characters'], exception.exit_code
        end

        should "create and attach aws role" do
          @external_account_creator.create

          assert_received(@external_account_creator.aws, :create_and_attach_role!) do |expect|
            expect.with do |external_account_id|
              assert_equal @external_account_creator.send(:external_account_id), external_account_id
            end
          end
        end

        context "#organization" do
          setup do
            stub_request(:get, /organizations.json*/).to_return(body: json_list(:empty, 1))
            remove_request_stub(@sub_organization_stub)
            stub_request(:put, /sub_organizations.json*/).to_return(body: json_list(:empty, 1))
          end

          should "fail if organization is not returned" do
            exception = assert_raises AddExternalAccountError do
              @external_account_creator.create
            end

            assert_match(/Organization not found/, exception.message)
            assert_equal AddExternalAccountError::EXIT_CODES['organization not found'], exception.exit_code
          end
        end

        context "#sub_organization" do
          setup do
            stub_request(:get, /organizations.json*/).to_return(body: json_list(:organization, 1))
            remove_request_stub(@sub_organization_stub)
          end

          should "fail if sub_organization is not found or created" do
            stub_request(:put, /sub_organizations.json*/).to_return(body: json_list(:empty, 1))
            stub_request(:post, /sub_organizations.json*/).to_return(status: 422, body: json(:error, :active_record))

            exception = assert_raises AddExternalAccountError do
              @external_account_creator.create
            end

            assert_match(/On Sub Organization/, exception.message)
            assert_equal AddExternalAccountError::EXIT_CODES['sub organization'], exception.exit_code
          end

          should "create sub organization if sub_organization is not found" do
            stub_request(:put, /sub_organizations.json*/).to_return(body: json_list(:empty, 1))
            sub_org_stub = stub_request(:post, /sub_organizations.json*/).to_return(status: 422, body: json(:sub_organization))

            @external_account_creator.create

            assert_requested sub_org_stub
            assert_not_nil @external_account_creator.send(:sub_organization)
          end
        end

        context "#team" do
          setup do
            stub_request(:get, /sub_organizations.json*/).to_return(body: json_list(:sub_organization, 1))
            remove_request_stub(@team_stub)
          end

          should "fail if team is not found or created" do
            stub_request(:put, /teams.json*/).to_return(body: json_list(:empty, 1))
            stub_request(:post, /teams.json*/).to_return(status: 422, body: json(:error, :active_record))

            exception = assert_raises AddExternalAccountError do
              @external_account_creator.create
            end

            assert_match(/On Team/, exception.message)
            assert_equal AddExternalAccountError::EXIT_CODES['team'], exception.exit_code
          end

          should "create team if team is not found" do
            stub_request(:put, /teams.json*/).to_return(body: json_list(:empty, 1))
            team_stub = stub_request(:post, /teams.json*/).to_return(status: 422, body: json(:team))

            @external_account_creator.create

            assert_requested team_stub
            assert_not_nil @external_account_creator.send(:team)
          end
        end

        should "fail if external account is not created" do
          remove_request_stub @external_account_stub
          stub_request(:post, /external_accounts.json*/).to_return(status: 422, body: json(:error, :active_record))

          exception = assert_raises AddExternalAccountError do
            @external_account_creator.create
          end

          assert_match(/On External Account/, exception.message)
          assert_equal AddExternalAccountError::EXIT_CODES['external account'], exception.exit_code
        end

        should "create and return external_account" do
          external_account = @external_account_creator.create

          assert_requested(:post, /external_accounts.json*/) do |req|
            body = JSON.parse(req.body)
            assert_equal @external_account_creator.aws.create_and_attach_role!.role.arn, body['data']['attributes']['arn']
            assert_equal @external_account_creator.send(:external_account_id), body['data']['attributes']['external_id']
            assert_equal @external_account_creator.send(:team_name), body['data']['attributes']['name']
            assert_equal @external_account_creator.send(:sub_organization).id, body['data']['attributes']['sub_organization_id']
            assert_equal @external_account_creator.send(:team).id, body['data']['attributes']['team_id']
          end
          assert_not_nil external_account
        end
      end
    end
  end
end
