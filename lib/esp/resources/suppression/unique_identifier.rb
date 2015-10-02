module ESP
  class Suppression
    class UniqueIdentifier < ESP::Resource
      self.prefix += "suppressions/alert/:alert_id/"

      def self.find(*)
        fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use the ESP::Suppression object to search suppressions'
      end

      def update
        fail ESP::NotImplementedError
      end

      def destroy
        fail ESP::NotImplementedError
      end
    end
  end
end
