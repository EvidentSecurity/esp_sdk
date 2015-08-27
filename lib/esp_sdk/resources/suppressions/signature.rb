module ESP
  module Suppressions
    class Signature < ESP::Resource
      self.prefix += "suppressions/"

      def create
        original_prefix = self.class.prefix
        if attributes[:alert_id]
          self.class.prefix += "alert/:alert_id/"
          prefix_options[:alert_id] = alert_id
        end
        super
      ensure
        self.class.prefix = original_prefix
      end

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
