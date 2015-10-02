module ESP
  class Suppression
    class Region < ESP::Resource
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
