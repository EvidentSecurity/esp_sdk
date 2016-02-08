module ESP
  class Suppression
    class UniqueIdentifier < ESP::Resource
      self.prefix += "suppressions/alert/:alert_id/"
      # Not Implemented. You cannot search for Suppression::UniqueIdentifier.
      #
      # Regular ARELlike methods are disabled.  Use the ESP::Suppression object to search suppressions.
      def self.where(*)
        fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use the ESP::Suppression object to search suppressions'
      end

      # Not Implemented. You cannot search for Suppression::UniqueIdentifier.
      #
      # Regular ARELlike methods are disabled.  Use the ESP::Suppression object to search suppressions.
      def self.find(*)
        fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use the ESP::Suppression object to search suppressions'
      end

      # Not Implemented. You cannot update a Suppression::UniqueIdentifier.
      def update
        fail ESP::NotImplementedError
      end

      # Not Implemented. You cannot destroy a Suppression::UniqueIdentifier.
      def destroy
        fail ESP::NotImplementedError
      end

      # :singleton-method: create
      # Create a suppression for a unique identifier.
      #
      # Pass an +alert_id+, the suppression will be created based on that alert.
      #
      # :call-seq:
      #   create(attributes={})
      #
      # ==== Parameter
      #
      # +attributes+ | Required | A hash of unique identifier suppression attributes
      #
      # ==== Attributes
      #
      # See {API documentation}[http://api-docs.evident.io?ruby#suppression-unique-identifier-create] for valid arguments
      #
      # ==== Example
      #   create(alert_id: 5, reason: 'My very good reason for creating this suppression')

      # :method: save
      # Create a suppression for a unique identifier.
      #
      # Set an +alert_id+, the suppression will be created based on that alert.
      #
      # ==== Attributes
      #
      # See {API documentation}[http://api-docs.evident.io?ruby#suppression-unique-identifier-create] for valid arguments
      #
      # ==== Example
      #   suppression = new(alert_id: 5, reason: 'My very good reason for creating this suppression')
      #   suppression.save
    end
  end
end
