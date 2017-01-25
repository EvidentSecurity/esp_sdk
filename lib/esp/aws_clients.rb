require 'aws-sdk'

module ESP
  # @private
  class AWSClients
    include ActiveModel::Validations

    ESP_OWNER_ID = { "production" => "613698206329".freeze }.freeze
    AWS_ROLE_NAME       = "Evident-Service-Role-AutoCreate".freeze
    AWS_ROLE_POLICY_ARN = "arn:aws:iam::aws:policy/SecurityAudit".freeze

    validates :owner_id, length: { is: 12 }, numericality: true

    def create_and_attach_role!(external_account_id)
      role = iam.create_role(role_name: AWS_ROLE_NAME, assume_role_policy_document: trust_policy(external_account_id))
      iam.attach_role_policy(role_name: AWS_ROLE_NAME, policy_arn: AWS_ROLE_POLICY_ARN)
      role
    end

    def owner_id
      @owner_id ||= ec2.describe_security_groups.security_groups[0].owner_id
    end

    private

    def ec2
      @ec2 ||= Aws::EC2::Client.new
    end

    def iam
      @iam ||= Aws::IAM::Client.new
    end

    def esp_owner_id
      ESP_OWNER_ID.fetch(ESP.env, "762160981991")
    end

    def trust_policy(external_account_id) # rubocop:disable Metrics/MethodLength
      <<-TRUST_POLICY.gsub /^\s*/, ''
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::#{esp_owner_id}:root"
        },
        "Action": "sts:AssumeRole",
        "Condition": {
          "StringEquals": {
            "sts:ExternalId": "#{external_account_id}"
          }
        }
      }
    ]
  }
TRUST_POLICY
    end
  end
end
