module EspSdk
  class Configure
    def self.token=(token)
      @token = token
    end

    def self.token
      @token
    end

    def self.email=(email)
      @email
    end

    def self.email
      @email
    end
  end
end