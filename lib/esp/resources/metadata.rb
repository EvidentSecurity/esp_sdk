module ESP
  class Metadata < ESP::Resource
    # Not Implemented. You cannot search for Metadata.
    #
    # @return [void]
    def self.where(*)
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot create or update Metadata.
    #
    # @return [void]
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy Metadata.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # Returns a metadata object for the given alert_id
    # Convenience method to use instead of {.find} since an alert_id is required to return metadata.
    #
    # @param alert_id [Integer, Numeric, #to_i] Required ID of the alert to retrieve metadata for.
    # @return [ESP::Metadata]
    # @raise [ArgumentError] if no +alert_id+ is supplied.
    # @example
    #   alerts = ESP::Metadata.for_alert(1194)
    def self.for_alert(alert_id = nil)
      fail ArgumentError, "You must supply an alert id." unless alert_id.present?
      from = "#{prefix}alerts/#{alert_id}/metadata.json"
      find(:one, from: from)
    end

    # Find a Metadata object by id
    #
    # *call-seq* -> +super.find(id)+
    #
    # @overload find(id)
    #   @param id [Integer, Numeric, #to_i] Required ID of the metadata object to retrieve.
    # @overload find(scope, options)
    #   *call-seq* -> +super.find(:one, options)+
    #   @api private
    #   @param scope [Object] *Example:* +:one+
    #   @param options [Hash] +params: { alert_id: Integer }+
    #   @raise [ArgumentError] if no +alert_id+ is supplied.
    # @return [ESP::Metadata]
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
