module ESP
  class CustomSignature < ESP::Resource
    belongs_to :service, class_name: 'ESP::Service'
    belongs_to :organization, class_name: 'ESP::Organization'

    def self.run_sanity_test!(arguments = {})
      result = run_sanity_test(arguments)
      return result if result.is_a?(ActiveResource::Collection)
      result.message = result.errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(result)) # rubocop:disable Style/RaiseArgs
    end

    def self.run_sanity_test(arguments = {})
      arguments = arguments.with_indifferent_access
      arguments[:regions] = Array(arguments[:regions])
      new(arguments).run action: 'run_sanity_test'
    end

    def run!(arguments = {})
      result = run(arguments)
      return result if result.is_a?(ActiveResource::Collection)
      result.message = result.errors.full_messages.join(' ')

      fail(ActiveResource::ResourceInvalid.new(result)) # rubocop:disable Style/RaiseArgs
    end

    def run(arguments = {}) # rubocop:disable Metrics/MethodLength
      arguments = arguments.with_indifferent_access

      attributes['external_account_id'] ||= arguments[:external_account_id]
      attributes['regions'] ||= Array(arguments[:regions])

      fail ArgumentError, "You must supply an external_account_id." unless external_account_id.present?

      response = connection.post endpoint(arguments[:action]), to_json
      ESP::Alert.send(:instantiate_collection, self.class.format.decode(response.body))
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid => error
      self.class.new.tap do |signature|
        signature.load_remote_errors(error, true)
        signature.code = error.response.code
      end
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
