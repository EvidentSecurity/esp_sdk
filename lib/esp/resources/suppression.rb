module ESP
  class Suppression < ESP::Resource
    autoload :UniqueIdentifier, File.expand_path(File.dirname(__FILE__) + '/suppression/unique_identifier')
    autoload :Signature, File.expand_path(File.dirname(__FILE__) + '/suppression/signature')
    autoload :Region, File.expand_path(File.dirname(__FILE__) + '/suppression/region')

    # The organization this sub organization belongs to.
    #
    # @return [ESP::Organization]
    belongs_to :organization, class_name: 'ESP::Organization'

    # The user who created the suppression.
    #
    # @return [ESP::User]
    belongs_to :created_by, class_name: 'ESP::User'

    # The regions affected by this suppression.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Region>]
    def regions
      # When regions come back in an include, the method still gets called, to return the object from the attributes.
      return attributes['regions'] if attributes['regions'].present?
      return [] unless respond_to? :region_ids
      ESP::Region.where(id_in: region_ids)
    end

    # The external accounts affected by this suppression.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::ExternalAccount>]
    def external_accounts
      # When external_accounts come back in an include, the method still gets called, to return the object from the attributes.
      return attributes['external_accounts'] if attributes['external_accounts'].present?
      return [] unless respond_to? :external_account_ids
      ESP::ExternalAccount.where(id_in: external_account_ids)
    end

    # The signatures being suppressed.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Signature>]
    def signatures
      # When signatures come back in an include, the method still gets called, to return the object from the attributes.
      return attributes['signatures'] if attributes['signatures'].present?
      return [] unless respond_to? :signature_ids
      ESP::Signature.where(id_in: signature_ids)
    end

    # The custom signatures being suppressed.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::CustomSignature>]
    def custom_signatures
      # When custom_signatures come back in an include, the method still gets called, to return the object from the attributes.
      return attributes['custom_signatures'] if attributes['custom_signatures'].present?
      return [] unless respond_to? :custom_signature_ids
      ESP::CustomSignature.where(id_in: custom_signature_ids)
    end

    # Overriden so the correct param is sent on the has_many relationships.  API needs this one to be plural.
    #
    # @private
    def self.element_name
      'suppressions'
    end

    # Not Implemented. You cannot create or update a Suppression.
    #
    # @return [void]
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Suppression.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # Deactivate the current suppression instance.
    # The current object will be updated with the new status if successful.
    # Throws an error if not successful.
    # === Once deactivated the suppression cannot be reactivated.
    #
    # @return [void]
    # @raise [ActiveResource::ResourceInvalid] if unsuccessful.
    def deactivate!
      return self if deactivate
      self.message = errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(self)) # rubocop:disable Style/RaiseArgs
    end

    # Deactivate the current suppression instance.
    # The current object will be updated with the new status if successful.
    # If not successful, populates its errors object.
    # === Once deactivated the suppression cannot be reactivated.
    #
    # @return [Net::HTTPSuccess, false]
    def deactivate
      patch(:deactivate).tap do |response|
        load_attributes_from_response(response)
      end
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid, ActiveResource::UnauthorizedAccess => error
      load_remote_errors(error, true)
      self.code = error.response.code
      false
    end

    # @!method self.where(clauses = {})
    #   Return a paginated Suppression list filtered by search parameters
    #
    #   *call-seq* -> +super.where(clauses = {})+
    #
    #   @param clauses [Hash] A hash of attributes with appended predicates to search, sort and include.
    #     ===== Valid Clauses
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#suppression-attributes] for valid arguments
    #   @return [ActiveResource::PaginatedCollection<ESP::Suppression>]

    # @!method self.find(id, options = {})
    #   Find a Suppression by id
    #
    #   *call-seq* -> +super.find(id, options = {})+
    #
    #   @param id [Integer, Numeric, #to_i] Required ID of the suppression to retrieve.
    #   @param options [Hash] Optional hash of options.
    #     ===== Valid Options
    #
    #     +include+ | The list of associated objects to return on the initial request.
    #
    #     ===== Valid Includable Associations
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#suppression-attributes] for valid arguments
    #   @return [ESP::Suppression]

    # @!method self.all
    #   Return a paginated Suppression list
    #
    #   @return [ActiveResource::PaginatedCollection<ESP::Suppression>]
  end
end
