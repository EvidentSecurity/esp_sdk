module ESP
  class Credentials
    @@access_key_id = ENV['ESP_ACCESS_KEY_ID']
    cattr_accessor :access_key_id

    @@secret_access_key = ENV['ESP_SECRET_ACCESS_KEY']
    cattr_accessor :secret_access_key
  end
end
