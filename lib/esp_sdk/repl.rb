module ESP
  # Current context in the ESP REPL
  class Repl
    attr_reader :client, :options, :results

    def initialize(options = {})
      @options = options
      @client = ESP::Api.new(@options)
    end

    # Override eval to delegate to the scripting eval
    def eval
      @results = client.custom_signatures.run_raw(
        signature: @options[:signature],
        language: @options[:language],
        regions: Array(@options[:region]),
        external_account_id: @options[:external_account_id])
    end

    def signature
      @options[:signature]
    end

    def set_signature(signature, language = :javascript)
      @options[:signature] = signature
      @options[:language] = language
      true
    end

    def region
      @options[:region]
    end

    def set_region(region) # rubocop:disable Style/AccessorMethodName
      @options[:region] = region
    end

    def external_account_id
      @options[:external_account_id]
    end

    def set_external_account_id(id) # rubocop:disable Style/AccessorMethodName
      @options[:external_account_id] = id
    end

    # Used to reset the client
    def reload!
      @client = ESP::Api.new(@options)
      'Reloaded!'
    end

    # Delegate to @client
    def method_missing(meth, *args, &block)
      if client.respond_to?(meth)
        client.send(meth, *args, &block)
      else
        super
      end
    end
  end
end
