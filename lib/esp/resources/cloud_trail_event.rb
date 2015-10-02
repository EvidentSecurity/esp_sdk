module ESP
  class CloudTrailEvent < ESP::Resource
    def save
      fail ESP::NotImplementedError
    end

    def destroy
      fail ESP::NotImplementedError
    end

    def self.for_alert(alert_id = nil)
      fail ArgumentError, "You must supply an alert id." unless alert_id.present?
      from = "#{prefix}alerts/#{alert_id}/cloud_trail_events.json"
      find(:all, from: from)
    end

    def self.find(*arguments)
      scope = arguments.slice!(0)
      options = (arguments.slice!(0) || {}).with_indifferent_access
      return super(scope, options) if options[:from].present?
      params = options.fetch(:params, {}).with_indifferent_access
      alert_id = params.delete(:alert_id)
      for_alert(alert_id)
    end
  end
end
