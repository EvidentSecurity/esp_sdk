module ESP
  class Signature < ESP::Resource
    ##
    # The service this signature belongs to.
    belongs_to :service, class_name: 'ESP::Service'

    # Run a signature.
    # Returns a collection of alerts.
    # Throws an error if not successful.
    #
    # ==== Valid Arguments
    #
    # * +external_account_id+ - The external account to run the signature against.
    # * +signature_name+ - The name of the signature to run.
    # * +regions+ - An array of regions to run the custom signature in
    #
    # ==== Example
    #   alerts = ESP::Signature.run!(signature_name: 'cloud_trails_enabled', external_account_id: 3, regions: ['us_east_1'])
    def self.run!(arguments = {})
      result = run(arguments)
      return result if result.is_a?(ActiveResource::Collection)
      result.message = result.errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(result)) # rubocop:disable Style/RaiseArgs
    end

    # Run a signature.
    # Returns a collection of alerts.
    # If not successful, returns a Signature object with the errors object populated.
    #
    # ==== Valid Arguments
    #
    # * +external_account_id+ - The external account to run the signature against.
    # * +signature_name+ - The name of the signature to run.
    # * +regions+ - An array of regions to run the custom signature in
    #
    # ==== Example
    #   alerts = ESP::Signature.run(signature_name: 'cloud_trails_enabled', external_account_id: 3, regions: ['us_east_1'])
    def self.run(arguments = {})
      arguments = arguments.with_indifferent_access
      arguments[:regions] = Array(arguments[:regions])

      new(arguments).run
    end

    # Returns a list of all the signature names
    def self.names
      get(:signature_names)
    end

    # Used internally, not part of the public API
    def run # :nodoc:
      fail ArgumentError, "You must supply an external_account_id." unless respond_to?(:external_account_id) && external_account_id.present?
      response = connection.post("#{self.class.prefix}external_account/#{external_account_id}/signatures/run.json", to_json)
      ESP::Alert.send(:instantiate_collection, self.class.format.decode(response.body))
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid => error
      self.class.new.tap do |signature|
        signature.load_remote_errors(error, true)
        signature.code = error.response.code
      end
    end
  end
end
