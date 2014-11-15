module EspSdk
  class Configure
    attr_accessor :token, :email, :version, :token_expires_at

    def initialize(options)
      @email   = options[:email]
      @version = options[:version] || 'v1'
      token_setup(options)
    end

    def uri
      return @uri if @uri.present?

      if EspSdk.production?
        @uri = 'https://api.evident.io/api'
      elsif EspSdk.release?
        @uri = 'https://api-rel.evident.io/api'
      else
        @uri = 'http://0.0.0.0:3001/api'
      end
    end

    private

    def token_setup(options)
      self.token = options[:password] || options[:token]
      end_point  = options[:password].present? ? 'new' : 'valid'
      client     = Client.new(self)
      response   = client.connect("#{uri}/#{version}/token/#{end_point}")
      user       = JSON.load(response.body)
      self.token = user['authentication_token']
      self.token_expires_at = user['token_expires_at'].to_s.to_datetime.utc ||
        1.hour.from_now.to_datetime.utc
    end
  end
end
