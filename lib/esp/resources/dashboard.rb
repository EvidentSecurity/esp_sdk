module ESP
  class Dashboard < ESP::Resource
    # Not Implemented. You cannot search for a Dashboard.
    #
    # Regular ARELlike methods are disabled.
    #
    # @return [void]
    def self.find(*)
      fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use the .recent method.'
    end

    # Not Implemented. You cannot search for a Dashboard.
    #
    # Regular ARELlike methods are disabled.
    #
    # @return [void]
    def self.where(*)
      fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use the .recent method.'
    end

    # Not Implemented. You cannot create or update a Dashboard.
    #
    # @return [void]
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Dashboard.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # @api private
    # Returns with data from reports run in the last 2 hours
    #
    # @return [ESP::Dashboard]
    def self.recent
      # call find_every directly since find is overridden/not implemented
      find_every from: "#{prefix}dashboard/recent.#{format.extension}"
    end
  end
end
