module ESP
  class Service < ESP::Resource
    ##
    # The collection of signatures associated with this service.
    has_many :signatures, class_name: 'ESP::Signature'

    # Not Implemented. You cannot create or update a Service.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Service.
    def destroy
      fail ESP::NotImplementedError
    end

    ##
    # :singleton-method: find
    # Find a Service by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the service to retrieve
    #
    # :call-seq:
    #  find(id)

    # :singleton-method: all
    # Return a paginated Service list
  end
end
