module ESP
  module Suppressions
    class UniqueIdentifier < ESP::Resource
      self.prefix += "suppressions/alert/:alert_id/"

      def self.find(*)
        fail ESP::NotImplemented, 'Regular ARELlike methods are disabled.  Use the ESP::Suppression object to search suppressions'
      end

      def update
        fail ESP::NotImplemented
      end

      def destroy
        fail ESP::NotImplemented
      end
    end
  end
end
