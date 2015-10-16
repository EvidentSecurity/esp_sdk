module ESP
  class Alert < ESP::Resource
    ##
    # Returns the cloud trail events associated with this alert.
    has_many :cloud_trail_events, class_name: 'ESP::CloudTrailEvent'

    # Not Implemented. You cannot create or update an Alert.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a an Alert.
    def destroy
      fail ESP::NotImplementedError
    end

    # Returns a paginated collection of alerts for the given report_id
    # Convenience method to use instead of ::find since a report_id is required to return alerts.
    #
    # ==== Attributes
    #
    # * +report_id+ - The ID for the report for wanted alerts.
    # * +arguments+ - An optional hash of search criteria to filter the returned collection.
    # Valid arguments are
    # * +region_id+ - Return only alerts for this region.
    # * +status+ - Return only alerts for the give status(es).  Valid values are fail, warn, error, pass, info
    # * +first_seen+ - Return only alerts first seen after this time.  Format: "2015-10-15 10:29:45"
    # * +suppressed+ - Return only suppressed alerts
    # * +team_id+ - Return only alerts for the given team.
    # * +external_account_id+ - Return only alerts for the given external id.
    # * +service_id+ - Return only alerts on signatures with the given service.
    # * +signature_severity+ - Return only alerts for signatures with the given risk_level.  Valid values are Low, Medium, High
    # * +signature_name+ - Return only alerts for signatures with hte given name.
    # * +resource+ - Return only alerts for the given resource or tag.
    # * +signature_identifier+ - Return only alerts for signatures with the given identifier.
    #
    # ==== Example
    #   alerts = ESP::Alert.for_report(54, status: 'fail', signature_severity: 'High')
    def self.for_report(report_id = nil, arguments = {})
      fail ArgumentError, "You must supply a report id." unless report_id.present?
      from = "#{prefix}reports/#{report_id}/alerts.json"
      all(from: from, params: arguments)
    end

    # Used internally by ::for_report
    def self.find(*arguments) # :nodoc:
      scope = arguments.slice!(0)
      return super(scope) if scope.is_a? Numeric
      options = (arguments.slice!(0) || {}).with_indifferent_access
      return super(scope, options) if options[:from].present?
      params = options.fetch(:params, {}).with_indifferent_access
      report_id = params.delete(:report_id)
      for_report(report_id, params)
    end

    # Suppress the signature associated with this alert.
    # ==== Attribute
    #
    # * +reason+ - The reason for creating the suppression.
    def suppress_signature(reason = nil)
      suppress(Suppression::Signature, reason)
    end

    # Suppress the region associated with this alert.
    # ==== Attribute
    #
    # * +reason+ - The reason for creating the suppression.
    def suppress_region(reason = nil)
      suppress(Suppression::Region, reason)
    end

    # Suppress the unique identifier associated with this alert.
    # ==== Attribute
    #
    # * +reason+ - The reason for creating the suppression.
    def suppress_unique_identifier(reason = nil)
      suppress(Suppression::UniqueIdentifier, reason)
    end

    private

    # Overridden because alerts does not use ransack for searching
    def self.filters(params)
      { filter: params }
    end

    def suppress(klass, reason)
      fail ArgumentError, "You must specify the reason.".freeze unless reason.present?
      klass.create(alert_id: id, reason: reason)
    end
  end
end
