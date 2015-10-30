module ESP
  class Suppression < ESP::Resource
    ##
    # The organization this sub organization belongs to.
    belongs_to :organization, class_name: 'ESP::Organization'

    ##
    # The user who created the suppression.
    belongs_to :created_by, class_name: 'ESP::User'

    # Not Implemented. You cannot create or update a Suppression.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Suppression.
    def destroy
      fail ESP::NotImplementedError
    end

    # Deactivate the current suppression instance.
    # The current object will be updated with the new status if successful.
    # Throws an error if not successful.
    # === Once deactivated the suppression cannot be reactivated.
    def deactivate!
      return self if deactivate
      self.message = errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(self)) # rubocop:disable Style/RaiseArgs
    end

    # Deactivate the current suppression instance.
    # The current object will be updated with the new status if successful.
    # If not successful, populates its errors object.
    # === Once deactivated the suppression cannot be reactivated.
    def deactivate
      patch(:deactivate).tap do |response|
        load_attributes_from_response(response)
      end
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid, ActiveResource::UnauthorizedAccess => error
      load_remote_errors(error, true)
      self.code = error.response.code
      false
    end

    ##
    # :singleton-method: find
    # Find a Suppression by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the suppression to retrieve
    #
    # :call-seq:
    #  find(id)

    # :singleton-method: all
    # Return a paginated Suppression list
  end
end
