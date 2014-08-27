require 'net/http'
require 'uri'

module EspSdk
  class Client
    attr_reader :config

    def initialize(config)
      @config  = config
    end

    def connect(url, type=:Get)
      begin
        uri     = URI(url)
        http    = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP.const_get(type).new uri, { 'Authorization' => @config.token, 'Authorization-Email' => @config.email }
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