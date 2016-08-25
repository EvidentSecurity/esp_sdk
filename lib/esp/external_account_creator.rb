module ESP
  # @private
  class AddExternalAccountError < StandardError
    EXIT_CODES = {
      '12 characters'          => 98,
      'not a number'           => 97,
      'organization not found' => 96,
      'sub organization'       => 95,
      'team'                   => 94,
      'external account'       => 93
    }.freeze

    def initialize(message = nil)
      super
    end

    def exit_code
      EXIT_CODES.detect { |key, _code| message =~ /#{key}/i }.last
    rescue StandardError
      1
    end
  end

  # @private
  class ExternalAccountCreator
    attr_reader :aws

    def initialize
      @aws = AWSClients.new
    end

    # @return [ESP::ExternalAccount]
    def create
      fail ESP::AddExternalAccountError, aws.errors.full_messages.join(', ') unless aws.valid?

      puts "adding AWS account #{aws.owner_id} to ESP as #{team_name}" unless ESP.env.test? # rubocop:disable Rails/Output
      aws_role_object = aws.create_and_attach_role!(external_account_id)
      sleep 10

      puts "aws_role_arn = #{aws_role_object.role.arn}, external_id = #{external_account_id}, nickname = #{team_name}, esp_suborg_id = #{sub_organization.id}, esp_team_id = #{team.id}" unless ESP.env.test? # rubocop:disable Rails/Output
      external_account = ESP::ExternalAccount.create(arn: aws_role_object.role.arn, external_id: external_account_id, name: team_name, sub_organization_id: sub_organization.id, team_id: team.id)
      fail ESP::AddExternalAccountError, "On External Account: #{external_account.errors.full_messages.join(', ')}" unless external_account.errors.blank?
      external_account
    end

    private

    def external_account_id
      @external_id ||= ESP::ExternalAccount.new.generate_external_id
    end

    def organization
      @organization ||= ESP::Organization.last
      fail ESP::AddExternalAccountError, "Organization not found" if @organization.blank?
      @organization
    end

    def sub_organization
      @sub_org ||= begin
        sub_org = ESP::SubOrganization.where(name_eq: 'AutoCreate').first
        sub_org || ESP::SubOrganization.create(name: "AutoCreate", organization_id: organization.id)
      end
      fail ESP::AddExternalAccountError, "On Sub Organization: #{@sub_org.errors.full_messages.first}" unless @sub_org.errors.blank?
      @sub_org
    end

    def team_name
      "#{sub_organization.name} #{aws.owner_id}"
    end

    def team
      @team ||= begin
        team = ESP::Team.where(name: team_name, sub_organization_id: sub_organization.id).first
        team || ESP::Team.create(name: team_name, sub_organization_id: sub_organization.id)
      end
      fail ESP::AddExternalAccountError, "On Team: #{@team.errors.full_messages.first}" unless @team.errors.blank?
      @team
    end
  end
end
