module EspSdk
  class Configure
    attr_accessor :token, :email, :version
    attr_reader   :uri

    def initialize(options)
      @token   = options[:token]
      @email   = options[:email]
      @version = options[:version] || 'v1'
      @uri     = 'http://0.0.0.0:3001/api'
    end
  end
end