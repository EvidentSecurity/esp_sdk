module ESP
  class ScanInterval < ESP::Resource
    # The external account the scan interval belongs to
    #
    # @return [ESP::ExternalAccount]
    belongs_to :external_account, class_name: 'ESP::ExternalAccount'

    # The service the scan interval belongs to
    #
    # @return [ESP::Service]
    belongs_to :service, class_name: 'ESP::Service'

    # Find a Scan Interval by id
    #
    # *call-seq* -> +super.find(id)+
    #
    # @overload find(id)
    #   @param id [Integer, Numeric, #to_i] Required ID of the scan interval to retrieve.
    # @overload find(scope, options)
    #   *call-seq* -> +super.all(options)+
    #   @api private
    #   @param scope [Object] *Example:* +:all+
    #   @param options [Hash] +params: { external_account_id: Interger }+
    #   @raise [ArgumentError] if no +external_account_id+ is supplied.
    # @return [ESP::ScanInterval]
    def self.find(*arguments)
      scope = arguments.slice!(0)
      options = (arguments.slice!(0) || {}).with_indifferent_access
      # If the first option is a number, we are looking for a specific object.
      # Otherwise `all` calls this with either nil, or a hash of arguments, and we need
      # to use our custom finder to use the correct URL
      return super(scope, options) if scope.is_a?(Numeric) || options[:from].present?
      params = options.fetch(:params, {}).with_indifferent_access
      external_account_id = params.delete(:external_account_id)
      for_external_account(external_account_id)
    end

    # Returns a collection of scan_intervals for the given external_account_id
    # Convenience method to use instead of {.find} since an external_account_id is required to return alerts.
    #
    # @param external_account_id [Integer, Numeric] Required ID of the external account to retrieve scan intervals for.
    # @return [ActiveResource::PaginatedCollection<ESP::ScanInterval>]
    # @raise [ArgumentError] if no +external_account_id+ is supplied.
    # @example
    #   alerts = ESP::ScanInterval.for_external_account(54)
    def self.for_external_account(external_account_id = nil)
      fail ArgumentError, "You must supply an external account id." unless external_account_id.present?
      from = "#{prefix}external_accounts/#{external_account_id}/scan_intervals.json"
      all(from: from)
    end
  end
end
