module ESP
  class Alert < ESP::Resource
    has_many :cloud_trail_events, class_name: 'ESP::CloudTrailEvent'

    def save
      fail ESP::NotImplementedError
    end

    def destroy
      fail ESP::NotImplementedError
    end

    def self.for_report(report_id = nil, arguments = {})
      fail ArgumentError, "You must supply a report id." unless report_id.present?
      from = "#{prefix}reports/#{report_id}/alerts.json"
      all(from: from, params: arguments)
    end

    def self.find(*arguments)
      scope = arguments.slice!(0)
      return super(scope) if scope.is_a? Numeric
      options = (arguments.slice!(0) || {}).with_indifferent_access
      return super(scope, options) if options[:from].present?
      params = options.fetch(:params, {}).with_indifferent_access
      report_id = params.delete(:report_id)
      for_report(report_id, params)
    end

    def suppress_signature(reason = nil)
      suppress(Suppression::Signature, reason)
    end

    def suppress_region(reason = nil)
      suppress(Suppression::Region, reason)
    end

    def suppress_unique_identifier(reason = nil)
      suppress(Suppression::UniqueIdentifier, reason)
    end

    private

    # Overriden because alerts does not use ransack for searching
    def self.filters(params)
      { filter: params }
    end

    def suppress(klass, reason)
      fail ArgumentError, "You must specify the reason.".freeze unless reason.present?
      klass.create(alert_id: id, reason: reason)
    end
  end
end
