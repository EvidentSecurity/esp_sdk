module ESP
  class Role < ESP::Resource
    # Not Implemented. You cannot create or update a Role.
    #
    # @return [void]
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a an Role.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot search for a Role.
    #
    # @return [void]
    def self.where(*)
      fail ESP::NotImplementedError
    end

    # @!method self.find(id)
    #   Find a Region by id
    #
    #   *call-seq* -> +super.find(id)+
    #
    #   @param id [Integer, Numeric, #to_i] Required ID of the region to retrieve.
    #   @return [ESP::Region]

    # @!method self.all
    #   Return a paginated list.
    #
    #   @return [ActiveResource::PaginatedCollection<ESP::Region>]
  end
end
