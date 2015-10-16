module ESP
  class Suppression
    class Region < ESP::Resource
      self.prefix += "suppressions/"

      # Not Implemented. You cannot search for Suppression::Region.
      #
      # Regular ARELlike methods are disabled.  Use the ESP::Suppression object to search suppressions.
      def self.find(*)
        fail ESP::NotImplementedError, 'Regular ARELlike methods are disabled.  Use the ESP::Suppression object to search suppressions'
      end

      # Not Implemented. You cannot update a Suppression::Region.
      def update
        fail ESP::NotImplementedError
      end

      # Not Implemented. You cannot destroy a Suppression::Region.
      def destroy
        fail ESP::NotImplementedError
      end

      # This instance method is called by the #save method when new? is true.
      def create # :nodoc:
        original_prefix = self.class.prefix
        if attributes[:alert_id]
          self.class.prefix += "alert/:alert_id/"
          prefix_options[:alert_id] = alert_id
        end
        super
      ensure
        self.class.prefix = original_prefix
      end

      # :singleton-method: create
      # Create a suppression for a region.
      #
      # If you pass an +alert_id+, include the +reason+ and all other params will be ignored, and the suppression will be created based on that alert.
      #
      # ==== Attributes
      #
      # * +alert_id+ - Required if creating a suppression for an alert. The id for the alert you want to create a suppression for.
      # * +regions+ - Required if not creating a suppression for an alert.  An array of regions to suppress.
      # * +external_account_ids+ - Required if not creating a suppression for an alert.  An Array of the external account ids to suppress the regions on.
      # * +reason+ - Required.  The reason for creating the suppression.
      #
      # :call-seq:
      #   create(alert_id: 5, reason: 'My very good reason for creating this suppression')
      #   create(regions: ['us_east_1'], external_account_ids: [5], reason: 'My very good reason for creating this suppression')

      # :method: save
      # Create a suppression for a region.
      #
      # If you set an +alert_id+, set the +reason+ and all other params will be ignored, and the suppression will be created based on that alert.
      #
      # ==== Attributes
      #
      # * +alert_id+ - Required if creating a suppression for an alert. The id for the alert you want to create a suppression for.
      # * +regions+ - Required if not creating a suppression for an alert.  An array of regions to suppress.
      # * +external_account_ids+ - Required if not creating a suppression for an alert.  An Array of the external account ids to suppress the regions on.
      # * +reason+ - Required.  The reason for creating the suppression.
      #
      # :call-seq:
      #   save
      #   new(alert_id: 5, reason: 'My very good reason for creating this suppression').save
      #   new(regions: ['us_east_1'], external_account_ids: [5], reason: 'My very good reason for creating this suppression').save
    end
  end
end
