require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module ESP
  class CredentialsTest < ActiveSupport::TestCase
    context ESP::Credentials do
      setup do
        @original_access_key_id = ENV['ESP_ACCESS_KEY_ID']
        @original_secret_access_key = ENV['ESP_SECRET_ACCESS_KEY']
      end

      teardown do
        ESP::Credentials.access_key_id = nil
        ESP::Credentials.secret_access_key = nil
        ENV['ESP_ACCESS_KEY_ID'] = @original_access_key_id
        ENV['ESP_SECRET_ACCESS_KEY'] = @original_secret_access_key
      end

      context '.access_key_id' do
        should 'be set manually' do
          ESP::Credentials.access_key_id = '1234'

          assert_equal '1234', ESP::Credentials.access_key_id
        end

        should 'be set from an environment variable' do
          ENV['ESP_ACCESS_KEY_ID'] = '4321'
          load File.expand_path('../../lib/esp/credentials.rb', File.dirname(__FILE__))

          assert_equal '4321', ESP::Credentials.access_key_id
        end
      end

      context '.secret_access_key' do
        should 'be set manually' do
          ESP::Credentials.secret_access_key = '1234'

          assert_equal '1234', ESP::Credentials.secret_access_key
        end

        should 'be set from an environment variable' do
          ENV['ESP_SECRET_ACCESS_KEY'] = '4321'
          load File.expand_path('../../lib/esp/credentials.rb', File.dirname(__FILE__))

          assert_equal '4321', ESP::Credentials.secret_access_key
        end
      end
    end
  end
end
