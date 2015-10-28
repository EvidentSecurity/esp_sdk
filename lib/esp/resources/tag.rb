module ESP
  class Tag < ESP::Resource
    # Not Implemented. You cannot create or update a Tag.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Tag.
    def destroy
      fail ESP::NotImplementedError
    end

    # Returns a paginated collection of tags for the given alert_id
    # Convenience method to use instead of ::find since an alert_id is required to return tags.
    #
    # ==== Attributes
    #
    # * +alert_id+ - The ID for the alert for wanted tags.
    #
    # ==== Example
    #   alerts = ESP::Tag.for_alert(1194)
    def self.for_alert(alert_id = nil)
      fail ArgumentError, "You must supply an alert id." unless alert_id.present?
      from = "#{prefix}alerts/#{alert_id}/tags.json"
      find(:all, from: from)
    end

    # Find a Tag by id
    # :call-seq:
    #  find(id)
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
