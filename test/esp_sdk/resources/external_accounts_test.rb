require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class ExternalAccountsTest < ActiveSupport::TestCase
  context 'ExternalAccounts' do
    setup do
      # Stub the token setup for our configuration object
      ESP::Configure.any_instance.expects(:token_setup).returns(nil).at_least_once
      @config = ESP::Configure.new(email: 'test@evident.io')
      @external_accounts = ESP::ExternalAccounts.new(@config)
    end

    context '#generate_external_id' do
      should 'call SecureRandom.uuid' do
        SecureRandom.expects(:uuid)
        @external_accounts.generate_external_id
      end
    end
  end
end
