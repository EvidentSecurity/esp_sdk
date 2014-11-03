module EspSdk
  class Configure
    attr_accessor :token, :email, :version, :token_expires_at

    def initialize(options)
      @email    = options[:email]
      @version  = options[:version] || 'v1'
      @token    = options[:token]
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
  end
end
