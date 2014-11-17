module RestClient
  class Request
    # Override execute to always use SSLv23
    def self.execute(args, &block)
      args.merge!(ssl_version: 'SSLv23')
      new(args).execute(& block)
    end
  end
end
