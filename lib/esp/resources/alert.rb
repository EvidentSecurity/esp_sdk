module ESP
  class Alert < ESP::Resource
    ##
    # Returns the external account associated with this alert.
    belongs_to :external_account, class_name: 'ESP::ExternalAccount'

    ##
    # Returns the region associated with this alert.
    belongs_to :region, class_name: 'ESP::Region'

    ##
    # Returns the region associated with this alert.  Either a signature or custom signature but not both will be present.
    belongs_to :signature, class_name: 'ESP::Signature'

    ##
    # Returns the custom signature associated with this alert.  Either a signature or custom signature but not both will be present.
    belongs_to :custom_signature, class_name: 'ESP::CustomSignature'

    ##
    # Returns the suppression associated with this alert.  If present the alert was suppressed.
    belongs_to :suppression, class_name: 'ESP::Suppression'

    ##
    # Returns the cloud trail events associated with this alert.  These may be added up to 10 minutes after the alert was created
    has_many :cloud_trail_events, class_name: 'ESP::CloudTrailEvent'

    ##
    # Returns the tags associated with this alert.
    has_many :tags, class_name: 'ESP::Tag'

    ##
    # Returns the metadata associated with this alert.
    def metadata
      ESP::Metadata.for_alert(id)
    end

    # Not Implemented. You cannot create or update an Alert.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a an Alert.
    def destroy
      fail ESP::NotImplementedError
    end

    # Returns a paginated collection of alerts for the given report_id
    #
    # ==== Parameters
    #
    # +clauses+ | Required | Hash of attributes with appended predicates to search, sort and include.
    #
    # ===== Valid Clauses
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#searching-alerts] for valid arguments
    #
    # ==== Example
    #   alerts = ESP::Alert.where(report_id: 54, status_eq: 'fail', signature_risk_level_in: ['High'], include: 'signature')
    def self.where(clauses = {})
      clauses = clauses.with_indifferent_access
      return super(clauses) if clauses[:from].present?
      from = for_report(clauses.delete(:report_id))
      super clauses.merge(from: from)
    end

    # Find an Alert by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the alert to retrieve
    #
    # +options+ | Optional | A hash of options
    #
    # ===== Valid Options
    #
    # +include+ | The list of associated objects to return on the initial request.
    #
    # ===== Valid Includable Associations
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#searching-alerts] for valid arguments
    #
    # ==== Example
    # alert = ESP::Alert.find(1, include: 'tags,external_account.team')
    #
    # :call-seq:
    #  find(id, options = {})
    def self.find(*arguments)
      scope = arguments.slice!(0)
      options = (arguments.slice!(0) || {}).with_indifferent_access
      return super(scope, options) if scope.is_a?(Numeric) || options[:from].present?
      params = options.fetch(:params, {})
      from = for_report(params.delete(:report_id))
      all(from: "#{from}.json", params: params)
    end

    def self.for_report(report_id) # :nodoc:
      fail ArgumentError, "You must supply a report id." unless report_id.present?
      "#{prefix}reports/#{report_id}/alerts"
    end

    # Suppress the signature associated with this alert.
    # ==== Parameter
    #
    # +reason+ | Required | The reason for creating the suppression.
    def suppress_signature(reason = nil)
      suppress(Suppression::Signature, reason)
    end

    # Suppress the region associated with this alert.
    # ==== Parameter
    #
    # +reason+ | Required | The reason for creating the suppression.
    def suppress_region(reason = nil)
      suppress(Suppression::Region, reason)
    end

    # Suppress the unique identifier associated with this alert.
    # ==== Parameter
    #
    # +reason+ | Required | The reason for creating the suppression.
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
