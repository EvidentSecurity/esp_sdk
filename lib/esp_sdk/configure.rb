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

      if ENV['RAILS_ENV'].present? || !!defined?(Rails)
        if ENV['RAILS_ENV'] == 'release'
          @uri = 'https://sig-api-release.evident.io'
        elsif (ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test') || (!!defined?(Rails) && ( Rails.env.development? || Rails.env.test? ))
          @uri = 'http://0.0.0.0:3001/api'
        else
          @uri = 'https://sig-api.evident.io'
        end
      else
        @uri = 'https://sig-api.evident.io'
      end
    end

    def uri
      Configure.end_point
    end
  end
end
