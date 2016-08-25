module ESP
  class Alert < ESP::Resource
    # Returns the external account associated with this alert.
    # @return [ESP::ExternalAccount]
    belongs_to :external_account, class_name: 'ESP::ExternalAccount'

    # Returns the region associated with this alert.
    # @return [ESP::Region]
    belongs_to :region, class_name: 'ESP::Region'

    # Returns the region associated with this alert.  Either a signature or custom signature but not both will be present.
    # @return [ESP::Signature]
    belongs_to :signature, class_name: 'ESP::Signature'

    # Returns the custom signature associated with this alert.  Either a signature or custom signature but not both will be present.
    # @return [ESP::CustomSignature]
    belongs_to :custom_signature, class_name: 'ESP::CustomSignature'

    # Returns the suppression associated with this alert.  If present the alert was suppressed.
    # @return [ESP::Suppression]
    belongs_to :suppression, class_name: 'ESP::Suppression'

    # Returns the cloud trail events associated with this alert.  These may be added up to 10 minutes after the alert was created
    # @return [ActiveResource::PaginatedCollection<ESP::CloudTrailEvent>]
    has_many :cloud_trail_events, class_name: 'ESP::CloudTrailEvent'

    # Returns the tags associated with this alert.
    # @return [ActiveResource::PaginatedCollection<ESP::Tag>]
    has_many :tags, class_name: 'ESP::Tag'

    # Returns the metadata associated with this alert.
    #
    # @return [ESP::Metadata]
    def metadata
      ESP::Metadata.for_alert(id)
    end

    # Not Implemented. You cannot create or update an Alert.
    #
    # @return [void]
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy an Alert.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # Returns alerts for the given report_id
    #
    # *call-seq* -> +super.where(clauses)+
    #
    # @param clauses [Hash] Required hash of attributes with appended predicates to search, sort and include.
    #   ===== Valid Clauses
    #
    #   See {API documentation}[http://api-docs.evident.io?ruby#searching-alerts] for valid arguments
    # @return [ActiveResource::PaginatedCollection<ESP::Alert>]
    # @example
    #   alerts = ESP::Alert.where(report_id: 54, status_eq: 'fail', signature_risk_level_in: ['High'], include: 'signature')
    def self.where(clauses = {})
      clauses = clauses.with_indifferent_access
      return super(clauses) if clauses[:from].present?
      from = for_report(clauses.delete(:report_id))
      super clauses.merge(from: from)
    end

    # Find an Alert by id
    #
    # @overload find(id)
    #   @param id [Integer, Numeric, #to_i] Required ID of the alert to retrieve.
    # @overload find(id, options)
    #   @param id [Integer, Numeric, #to_i] Required ID of the alert to retrieve.
    #   @param options [Hash]
    #     ===== Valid Options
    #
    #     +include+ | The list of associated objects to return on the initial request.
    #
    #     ===== Valid Includable Associations
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#searching-alerts] for valid arguments
    # @overload find(_non_numeric, options)
    #   *call-seq* -> +super.all(options)+
    #   @param _non_numeric [Object] *Example:* +:all+
    #   @param options [Hash] +{ params: { report_id: Integer } }+
    # @return [ESP::Alert]
    # @example
    #   alert = ESP::Alert.find(1)
    #   alert = ESP::Alert.find(1, include: 'tags,external_account.team')
    #   alert = ESP::Alert.find(:all, params: { report_id: 5 })
    #
    def self.find(*arguments)
      scope = arguments.slice!(0)
      options = (arguments.slice!(0) || {}).with_indifferent_access
      return super(scope, options) if scope.is_a?(Numeric) || options[:from].present?
      params = options.fetch(:params, {})
      from = for_report(params.delete(:report_id))
      all(from: "#{from}.json", params: params)
    end

    # @private
    def self.for_report(report_id)
      fail ArgumentError, "You must supply a report id." unless report_id.present?
      "#{prefix}reports/#{report_id}/alerts"
    end

    # Suppress the signature associated with this alert.
    #
    # @param reason [String] Required reason for creating the suppression.
    # @return [ESP::Suppression::Signature]
    def suppress_signature(reason = nil)
      suppress(Suppression::Signature, reason)
    end

    # Suppress the region associated with this alert.
    #
    # @param reason [String] Required reason for creating the suppression.
    # @return [ESP::Suppression::Region]
    def suppress_region(reason = nil)
      suppress(Suppression::Region, reason)
    end

    # Suppress the unique identifier associated with this alert.
    #
    # @param reason [String] Required reason for creating the suppression.
    # @return [ESP::Suppression::UniqueIdentifier]
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
