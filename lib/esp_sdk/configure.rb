module EspSdk
  class Configure
    attr_accessor :token, :email, :version, :token_expires_at, :end_point, :domain

    def initialize(options)
      self.email = options[:email]
      self.version = options[:version] || 'v1'
      self.domain = options[:domain]
      self.token = options[:password] || options[:token]
      self.end_point = options[:password].present? ? 'new' : 'valid'
      token_setup
    end

    def url(endpoint)
      "#{domain}/api/#{version}/#{endpoint}"
    end

    def domain
      return @domain if @domain.present?
      if EspSdk.production?
        self.domain = 'https://api.evident.io'
      elsif EspSdk.release?
        self.domain = 'https://api-rel.evident.io'
      else
        self.domain = 'http://0.0.0.0:3000'
      end
    end

    private

    def token_setup
      client     = Client.new(self)
      response   = client.connect(url("token/#{end_point}"))
      user       = JSON.load(response.body)
      self.token = user['authentication_token']
      self.token_expires_at = user['token_expires_at'].to_s.to_datetime.utc ||
        1.hour.from_now.to_datetime.utc
    end
  end
end
