module ESP
  class RawAlert < ESP::Resource
    def self.find(*)
      fail ESP::NotImplemented, 'Regular ARELlike methods are disabled.  Use either the .recent or .timewarp method.'
    end

    def save
      fail ESP::NotImplemented
    end

    def destroy
      fail ESP::NotImplemented
    end
  end
end
