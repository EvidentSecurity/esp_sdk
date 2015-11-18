module ESP
  class Dashboard < ESP::Resource
    # Not Implemented. You cannot search for Suppression::Region.
    #
    # Regular ARELlike methods are disabled.
    def self.find(*)
      fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use the .recent method.'
    end

    # Not Implemented. You cannot search for Suppression::Region.
    #
    # Regular ARELlike methods are disabled.
    def self.where(*)
      fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use the .recent method.'
    end

    # Not Implemented. You cannot create or update a Dashboard.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Dashboard.
    def destroy
      fail ESP::NotImplementedError
    end

    # Returns a Dashboard object with data from reports run in the last 2 hours
    #
    # ==== Note
    #
    # The dashboard is used internally for the dashboard page on esp.evident.io and is therefore not considered
    # part of the public API and may change without notice.
    def self.recent
      # call find_every directly since find is overridden/not implemented
      find_every from: "#{prefix}dashboard/recent.#{format.extension}"
    end
  end
end
