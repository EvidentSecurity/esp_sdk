module ESP
  class CustomSignature < ESP::Resource
    belongs_to :service, class_name: 'ESP::Service'
    belongs_to :organization, class_name: 'ESP::Organization'

    def self.run_sanity_test!(params = {}) # rubocop:disable Style/OptionHash
      result = run_sanity_test(params)
      return result if result.is_a?(ActiveResource::Collection)
      result.message = result.errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(result)) # rubocop:disable Style/RaiseArgs
    end

    def self.run_sanity_test(params = {}) # rubocop:disable Style/OptionHash
      params = params.with_indifferent_access
      params[:regions] = Array(params[:regions])
      new(params).run action: 'run_sanity_test'
    end

    def run!(params = {}) # rubocop:disable Style/OptionHash
      result = run(params)
      return result if result.is_a?(ActiveResource::Collection)
      result.message = result.errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(result)) # rubocop:disable Style/RaiseArgs
    end

    def run(params = {}) # rubocop:disable Style/OptionHash
      params = params.with_indifferent_access

      attributes['external_account_id'] ||= params[:external_account_id]
      attributes['regions'] ||= Array(params[:regions])

      fail ArgumentError, "You must supply an external_account_id." unless external_account_id.present?

      response = connection.post endpoint(params[:action]), to_json
      ESP::Alert.send(:instantiate_collection, self.class.format.decode(response.body))
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid => error
      self.class.new.tap { |signature| signature.load_remote_errors(error, true) }
    end

    private

    def endpoint(action)
      action ||= 'run_existing'.freeze
      case action
      when 'run_existing'.freeze
        "#{self.class.prefix}external_account/#{external_account_id}/custom_signatures/#{id}/#{action}.json"
      when 'run_sanity_test'
        "#{self.class.prefix}external_account/#{external_account_id}/custom_signatures/#{action}.json"
      else
        fail 'Invalid action'
      end
    end
  end
end
