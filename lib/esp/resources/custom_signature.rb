module ESP
  class CustomSignature < ESP::Resource
    def self.run_sanity_test(params = {})
      submit_and_load(ESP::Alert, new(params))
    end

    def self.run_raw_sanity_test(params = {})
      submit_and_load(ESP::RawAlert, new(params))
    end

    def run(external_account_id = nil, regions = [])
      attributes['external_account_id'] ||= external_account_id
      attributes['regions'] ||= Array(regions)
      submit_and_load(ESP::Alert)
    end

    def run_raw(external_account_id = nil, regions = [])
      attributes['external_account_id'] ||= external_account_id
      attributes['regions'] ||= Array(regions)
      submit_and_load(ESP::RawAlert)
    end

    private

    def submit_and_load(klass)
      original_prefix = self.class.prefix
      self.class.prefix += "external_account/:external_account_id/"
      prefix_options[:external_account_id] = external_account_id
      response = post(:run_existing, {}, body = to_json)
      self.class.parse_response(response, klass)
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid => error
      self.class.new.tap { |signature| signature.load_remote_errors(error, true) }
    ensure
      self.class.prefix = original_prefix
    end

    def self.submit_and_load(klass, signature)
      original_prefix = self.prefix
      self.prefix += "external_account/:external_account_id/"
      response = post(:run_sanity_test, { external_account_id: signature.external_account_id }, body = signature.to_json)
      parse_response(response, klass)
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid => error
      new.tap { |signature| signature.load_remote_errors(error, true) }
    ensure
      self.prefix = original_prefix
    end

    def self.parse_response(response, klass)
      ActiveResource::Collection.new(format.decode(response.body)).tap do |parser|
        parser.resource_class = klass
        parser.original_params = {}
      end.collect! { |record| klass.new(record, true) }
    end
  end
end
