module ESP
  class Signature < ESP::Resource
    belongs_to :service, class_name: 'ESP::Service'

    def self.run!(params = {})
      result = run(params)
      return result if result.is_a?(ActiveResource::Collection)
      result.message = result.errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(result)) # rubocop:disable Style/RaiseArgs
    end

    def self.run(params = {})
      params = params.with_indifferent_access
      params[:regions] = Array(params[:regions])

      new(params).run
    end

    def self.names
      get(:signature_names)
    end

    def run
      fail ArgumentError, "You must supply an external_account_id." unless respond_to?(:external_account_id) && external_account_id.present?
      response = connection.post("#{self.class.prefix}external_account/#{external_account_id}/signatures/run.json", to_json)
      ESP::Alert.send(:instantiate_collection, self.class.format.decode(response.body))
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid => error
      self.class.new.tap { |signature| signature.load_remote_errors(error, true) }
    end
  end
end
