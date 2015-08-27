module ESP
  class Signature < ESP::Resource
    belongs_to :service, class_name: 'ESP::Service'

    def self.run(params = {})
      submit_and_load(ESP::Alert, params)
    end

    def self.run_raw(params = {})
      submit_and_load(ESP::RawAlert, params)
    end

    def self.names
      get(:signature_names)
    end

    private

    def self.run_params(params)
      { data: { type: 'signatures',
                attributes: params } }
    end

    def self.submit_and_load(klass, params)
      params = params.with_indifferent_access
      original_prefix = self.prefix
      self.prefix += "external_account/:external_account_id/"
      response = post(:run, { external_account_id: params[:external_account_id] }, body = run_params(params).to_json)
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
