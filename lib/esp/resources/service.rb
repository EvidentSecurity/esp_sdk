module ESP
  class Service < ESP::Resource
    # The collection of signatures associated with this service.
    #
    # @return [ActiveResource::PaginatedCollection<ESP::Signature>]
    has_many :signatures, class_name: 'ESP::Signature'

    # Not Implemented. You cannot search for a Tag.
    #
    # @return [void]
    def self.where(*)
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot create or update a Service.
    #
    # @return [void]
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Service.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # @!method self.find(id)
    #   Find a Service by id
    #
    #   *call-seq* -> +super.find(id)+
    #
    #   @param id [Integer, Numeric, #to_i] Required ID of the service to retrieve.
    #   @return [ESP::Service]

    # @!method self.all
    #   Return a paginated Service list
    #
    #   @return [ActiveResource::PaginatedCollection<ESP::Service>]
  end
end
