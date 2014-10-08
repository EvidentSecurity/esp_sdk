module EspSdk
  class Configure
    attr_accessor :token, :email, :version, :token_expires_at

    def initialize(options)
      @email    = options[:email]
      @version  = options[:version] || 'v1'
      @token    = options[:token]
    end

    def self.end_point
      return @uri if @uri.present?

      if ENV['RAILS_ENV'].present?
        if ENV['RAILS_ENV'] == 'release'
          @uri = 'https://api.release.evident.io/api'
        elsif ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
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