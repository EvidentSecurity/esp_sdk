module EspSdk
  class Configure
    attr_accessor :token, :email, :version, :token_expires_at

    def initialize(options)
      @email    = options[:email]
      @version  = options[:version] || 'v1'
      @token    = options[:token]

      if !!defined?(Rails)
        if Rails.env.release?
          @uri = 'https://api.release.evident.io/api'
        elsif Rails.env.development?
          @uri = 'http://0.0.0.0:3001/api'
        else
          @uri = 'https://api.evident.io/api'
        end
      else
        @uri = 'https://api.evident.io/api'
      end
    end

    def self.end_point
      if !!defined?(Rails)
        if Rails.env.release?
          @uri = 'https://api.release.evident.io/api'
        elsif Rails.env.development?
          @uri = 'http://0.0.0.0:3001/api'
        else
          @uri = 'https://api.evident.io/api'
        end
      else
        @uri = 'https://api.evident.io/api'
      end
    end

    def uri
      Configure.end_point
    end
  end
end