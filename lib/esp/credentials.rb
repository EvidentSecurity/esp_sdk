module ESP
  class Credentials
    cattr_accessor :access_key_id, :secret_access_key

    def self.access_key_id
      @@access_key_id || ENV['ESP_ACCESS_KEY_ID']
    end

    def self.secret_access_key
      @@secret_access_key || ENV['ESP_SECRET_ACCESS_KEY']
    end
  end
end
