module ESP
  class Signature < ESP::Resource
    # The service this signature belongs to.
    #
    # @return [ESP::Service]
    belongs_to :service, class_name: 'ESP::Service'

    # Not Implemented. You cannot create or update a Signature.
    #
    # @return [void]
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Signature.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # Run this signature.
    # Returns a collection of alerts.
    # Throws an error if not successful.
    #
    # @param (see #run)
    # @return [ActiveResource::PaginatedCollection<ESP::Alert>]
    # @raise [ActiveResource::ResourceInvalid] if not successful.
    # @example
    #   signature = ESP::Signature.find(3)
    #   alerts = signature.run!(external_account_id: 3, region: 'us_east_1')
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
    # @param arguments [Hash] Required hash of run arguments.
    #   ===== Valid Arguments
    #
    #   See {API documentation}[http://api-docs.evident.io?ruby#signature-run] for valid arguments
    # @return [ActiveResource::PaginatedCollection<ESP::Alert>, self]
    # @example
    #   signature = ESP::Signature.find(3)
    #   alerts = signature.run(external_account_id: 3, region: 'us_east_1')
    def run(arguments = {})
      arguments = arguments.with_indifferent_access
      attributes['external_account_id'] ||= arguments[:external_account_id]
      attributes['region'] ||= arguments[:region]

      response = connection.post("#{self.class.prefix}signatures/#{id}/run.json", to_json)
      ESP::Alert.send(:instantiate_collection, self.class.format.decode(response.body))
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid, ActiveResource::ResourceNotFound => error
      load_remote_errors(error, true)
      self.code = error.response.code
      self
    end

    # Create a suppression for this signature.
    #
    # @param arguments [Hash] Required hash of signature suppression attributes.
    #   ===== Valid Arguments
    #
    #   See {API documentation}[http://api-docs.evident.io?ruby#suppression-create] for valid arguments
    # @return [ESP::Suppression::Signature]
    # @example
    #   suppress(regions: ['us_east_1'], external_account_ids: [5], reason: 'My very good reason for creating this suppression')
    def suppress(arguments = {})
      arguments = arguments.with_indifferent_access
      ESP::Suppression::Signature.create(signature_ids: [id], regions: Array(arguments[:regions]), external_account_ids: Array(arguments[:external_account_ids]), reason: arguments[:reason])
    end

    # @!method self.where(clauses = {})
    #   Return a paginated Signature list filtered by search parameters
    #
    #   *call-seq* -> +super.where(clauses = {})+
    #
    #   @param clauses [Hash] A hash of attributes with appended predicates to search, sort and include.
    #     ===== Valid Clauses
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#signature-attributes] for valid arguments
    #   @return [ActiveResource::PaginatedCollection<ESP::Signature>]

    # @!method self.find(id)
    #   Find a Signature by id
    #
    #   *call-seq* -> +super.find(id, options = {})+
    #
    #   @overload find(id)
    #   @overload find(id, options={})
    #     @param options [Hash] Optional hash of options.
    #       ===== Valid Options
    #
    #       +include+ | The list of associated objects to return on the initial request.
    #
    #       ===== Valid Includable Associations
    #
    #       See {API documentation}[http://api-docs.evident.io?ruby#signature-attributes] for valid arguments
    #   @param id [Integer, Numeric, #to_i] Required ID of the signature to retrieve.
    #   @return [ESP::Signature]

    # @!method self.all
    #   Return a paginated Signature list
    #
    #   @return [ActiveResource::PaginatedCollection<ESP::Signature>]
  end
end
