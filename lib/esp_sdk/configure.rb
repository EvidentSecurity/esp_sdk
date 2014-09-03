module EspSdk
  class Configure
    attr_accessor :token, :email, :version, :token_expires_at
    attr_reader   :uri

    def initialize(options)
      @email    = options[:email]
      @version  = options[:version] || 'v1'
      @uri      = 'http://0.0.0.0:3001/api'
    end
  end
end