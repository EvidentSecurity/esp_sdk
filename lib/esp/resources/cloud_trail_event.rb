module ESP
  class CloudTrailEvent < ESP::Resource
    # Not Implemented. You cannot search for a CloudTrailEvent.
    #
    # @return [void]
    def self.where(*)
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot create or update a CloudTrailEvent.
    #
    # @return [void]
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a CloudTrailEvent.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # Returns cloud trail events for the given +alert_id+.
    # Convenience method to use instead of +::find+ since an +alert_id+ is required to return cloud trail events.
    #
    # @param alert_id [Integer, Numeric, #to_i] Required ID of the alert to retrieve cloud trail events for.
    # @return [ActiveResource::PaginatedCollection<ESP::CloudTrailEvent>]
    # @example
    #   alerts = ESP::CloudTrailEvent.for_alert(1194)
    def self.for_alert(alert_id = nil)
      fail ArgumentError, "You must supply an alert id." unless alert_id.present?
      from = "#{prefix}alerts/#{alert_id}/cloud_trail_events.json"
      find(:all, from: from)
    end

    # Find a CloudTrailEvent by id
    #
    # *call-seq* -> +super.find(id)+
    #
    # @overload find(id)
    #   @param id [Integer, Numeric, #to_i] Required ID of the cloud trail event to retrieve
    # @return [ESP::CloudTrailEvent]
    # @example
    #   alert = ESP::CloudTrailEvent.find(1)
    def self.find(*arguments)
      scope = arguments.slice!(0)
      options = (arguments.slice!(0) || {}).with_indifferent_access
      return super(scope, options) if scope.is_a?(Numeric) || options[:from].present?
      params = options.fetch(:params, {}).with_indifferent_access
      alert_id = params.delete(:alert_id)
      for_alert(alert_id)
    end
  end
end
