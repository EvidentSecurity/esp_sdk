module ESP
  class Signature < ESP::Resource
    ##
    # The service this signature belongs to.
    belongs_to :service, class_name: 'ESP::Service'

    # Not Implemented. You cannot create or update a Signature.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Signature.
    def destroy
      fail ESP::NotImplementedError
    end

    # Run this signature.
    # Returns a collection of alerts.
    # Throws an error if not successful.
    #
    # ==== Valid Arguments
    #
    # * +external_account_id+ - The external account to run the signature against.
    # * +regions+ - An array of regions to run the custom signature in
    #
    # ==== Example
    #   signature = ESP::Signature.find(3)
    #   alerts = signature.run(external_account_id: 3, regions: ['us_east_1'])
    def run!(arguments = {})
      result = run(arguments)
      return result if result.is_a?(ActiveResource::Collection)
      result.message = result.errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(result)) # rubocop:disable Style/RaiseArgs
    end

    # Run this signature.
    # Returns a collection of alerts.
    # If not successful, returns a Signature object with the errors object populated.
    #
    # ==== Valid Arguments
    #
    # * +external_account_id+ - The external account to run the signature against.
    # * +regions+ - An array of regions to run the custom signature in
    #
    # ==== Example
    #   signature = ESP::Signature.find(3)
    #   alerts = signature.run(external_account_id: 3, regions: ['us_east_1'])
    def run(arguments = {})
      arguments = arguments.with_indifferent_access
      attributes['external_account_id'] ||= arguments[:external_account_id]
      attributes['regions'] ||= Array(arguments[:regions])

      response = connection.post("#{self.class.prefix}signatures/#{id}/run.json", to_json)
      ESP::Alert.send(:instantiate_collection, self.class.format.decode(response.body))
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid => error
      load_remote_errors(error, true)
      self.code = error.response.code
      self
    end

    ##
    # :singleton-method: find
    # Find a Signature by id
    # :call-seq:
    #  find(id)
  end
end
