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
    def self.where(attrs)
      # when calling `recent.next_page` it will come into here
      if attrs[:from].to_s.include?('recent')
        super
      else
        fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use the .recent method.'
      end
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
      where from: "#{prefix}dashboard/recent"
    end
  end
end
