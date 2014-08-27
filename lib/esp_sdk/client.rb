require 'net/http'
require 'uri'

module EspSdk
  class Client
    attr_reader :version

    def initialize(token=EspSDK::Configure.token, email=EspSDK::Configure.email, version='v1')
      @token   = token
      @email   = email
      @version = version
    end

    def connect(url, type=:Get)
      begin
        puts "@@@@@@@@@ #{__FILE__}:#{__LINE__} \n********** url = " + url.inspect
        uri     = URI(url)
        http    = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP.const_get(type).new uri, { 'Authorization' => @token, 'Authorization-Email' => @email }
        http.start
        http.request(request)
      rescue Exception => e
          puts "@@@@@@@@@ #{__FILE__}:#{__LINE__} \n********** e.message = " + e.message.inspect
      ensure
        http.finish
      end
    end
  end
end