module ESP
  class CloudTrailEvent < ESP::Resource
    # Not Implemented. You cannot create or update a CloudTrailEvent.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a an CloudTrailEvent.
    def destroy
      fail ESP::NotImplementedError
    end

    # Returns a paginated collection of cloud trail events for the given alert_id
    # Convenience method to use instead of ::find since an alert_id is required to return cloud trail events.
    #
    # ==== Attributes
    #
    # * +alert_id+ - The ID for the alert for wanted cloud trail events.
    #
    # ==== Example
    #   alerts = ESP::CloudTrailEvent.for_alert(1194)
    def self.for_alert(alert_id = nil)
      fail ArgumentError, "You must supply an alert id." unless alert_id.present?
      from = "#{prefix}alerts/#{alert_id}/cloud_trail_events.json"
      find(:all, from: from)
    end

    # Used internally by ::for_alert
    def self.find(*arguments) # :nodoc:
      scope = arguments.slice!(0)
      options = (arguments.slice!(0) || {}).with_indifferent_access
      return super(scope, options) if options[:from].present?
      params = options.fetch(:params, {}).with_indifferent_access
      alert_id = params.delete(:alert_id)
      for_alert(alert_id)
    end
  end
end
