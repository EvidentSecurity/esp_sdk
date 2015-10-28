module ESP
  class Region < ESP::Resource
    # Not Implemented. You cannot create or update a CloudTrailEvent.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a an CloudTrailEvent.
    def destroy
      fail ESP::NotImplementedError
    end

    ##
    # :singleton-method: find
    # Find a Region by id
    # :call-seq:
    #  find(id)
  end
end
