require_relative '../test_helper'
require_relative '../../lib/esp/aws_clients'

module ESP
  class AWSClientsTest < ActiveSupport::TestCase
    context ESP::AWSClients do
      context 'validations' do
        should 'be 12 chars' do
          aws = AWSClients.new
          aws.stubs(:owner_id).returns("ABC123")

          refute aws.valid?
          assert_contains aws.errors.full_messages, 'Owner is the wrong length (should be 12 characters)'
        end

        should 'contain only numeric chars' do
          aws = AWSClients.new
          aws.stubs(:owner_id).returns("ABC123")

          refute aws.valid?
          assert_contains aws.errors.full_messages, 'Owner is not a number'
        end

        should 'contain 12 numeric chars' do
          aws = AWSClients.new
          aws.stubs(:owner_id).returns("012345678912")

          assert aws.valid?
        end
      end

      context "#create_and_attach_role" do
        setup do
          ENV['AWS_REGION'] = 'us-east-1'
        end

        teardown do
          ENV['AWS_REGION'] = nil
        end

        should "make iam call to create_role with external account id" do
          aws = AWSClients.new
          Aws::IAM::Client.any_instance.stubs(:create_role)
          Aws::IAM::Client.any_instance.stubs(:attach_role_policy)

          aws.create_and_attach_role!('1234')

          assert_received(Aws::IAM::Client.any_instance, :create_role) do |expected|
            expected.with do |params|
              assert_equal AWSClients::AWS_ROLE_NAME, params[:role_name]
              assert_equal aws.send(:trust_policy, '1234'), params[:assume_role_policy_document]
            end
          end
        end

        should "make iam call to attach_role_policy" do
          aws = AWSClients.new
          Aws::IAM::Client.any_instance.stubs(:create_role)
          Aws::IAM::Client.any_instance.stubs(:attach_role_policy)

          aws.create_and_attach_role!('1234')

          assert_received(Aws::IAM::Client.any_instance, :attach_role_policy) do |expected|
            expected.with do |params|
              assert_equal AWSClients::AWS_ROLE_NAME, params[:role_name]
              assert_equal AWSClients::AWS_ROLE_POLICY_ARN, params[:policy_arn]
            end
          end
        end

        should "return the role" do
          aws = AWSClients.new
          Aws::IAM::Client.any_instance.stubs(:create_role).returns('the role')
          Aws::IAM::Client.any_instance.stubs(:attach_role_policy)

          role = aws.create_and_attach_role!('1234')

          assert_equal 'the role', role
        end
      end

      context '#trust_policy' do
        should 'have the esp_owner_id and external_account_id' do
          aws = AWSClients.new
          ESP.stubs(:env).returns("production")

          policy = aws.send(:trust_policy, '1234')

          assert_match(/\"AWS\": \"arn:aws:iam::613698206329:root\"/, policy)
          assert_match(/\"sts:ExternalId\": \"1234"/, policy)
        end
      end
    end
  end
end
