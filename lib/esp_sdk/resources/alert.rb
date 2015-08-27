module ESP
  class Alert < ESP::Resource
    def save
      fail ESP::NotImplemented
    end

    def destroy
      fail ESP::NotImplemented
    end

    def self.for_report(report_id, params = {})
      raise ArgumentError, "expected a report_id" unless report_id.present?
      from = "#{prefix}reports/#{report_id}/alerts.json"
      find_every(from: from, params: params).tap do |collection|
        collection.from = from
        collection.original_params = params
      end
    end

    def self.find(*arguments)
      options = Hash(arguments.second)
      return super if options[:from].present?
      params = options.fetch(:params, {}).with_indifferent_access
      raise ArgumentError, "you must specify the report_id" unless params.has_key? :report_id
      for_report(params.delete(:report_id), params)
    end

    def suppress_signature(reason = nil)
      raise ArgumentError, "you must specify the reason" unless reason.present?
      Suppressions::Signature.create(alert_id: id, reason: reason)
    end

    def suppress_region(reason = nil)
      raise ArgumentError, "you must specify the reason" unless reason.present?
      Suppressions::Region.create(alert_id: id, reason: reason)
    end

    def suppress_unique_identifier(reason = nil)
      raise ArgumentError, "you must specify the reason" unless reason.present?
      Suppressions::UniqueIdentifier.create(alert_id: id, reason: reason)
    end
  end
end
