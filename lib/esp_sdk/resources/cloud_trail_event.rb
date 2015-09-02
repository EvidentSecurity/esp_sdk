module ESP
  class CloudTrailEvent < ESP::Resource
    def self.for_alert(alert_id, params = {})
      raise ArgumentError, "expected a alert_id" unless alert_id.present?
      from = "#{prefix}alerts/#{alert_id}/cloud_trail_events.json"
      find_every(from: from, params: params).tap do |collection|
        collection.from = from
        collection.original_params = params
      end
    end

    def self.find(*arguments)
      options = Hash(arguments.second)
      return super if options[:from].present?
      params = options.fetch(:params, {}).with_indifferent_access
      raise ArgumentError, "you must specify the alert_id" unless params.has_key? :alert_id
      for_alert(params.delete(:alert_id), params)
    end

    def save
      fail ESP::NotImplemented
    end

    def destroy
      fail ESP::NotImplemented
    end
  end
end
