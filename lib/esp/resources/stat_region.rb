module ESP
  class StatRegion < ESP::Resource
    include ESP::StatTotals

    # The region these stats are for.
    #
    # @return [ESP::Region]
    belongs_to :region, class_name: 'ESP::Region'

    # Not Implemented. You cannot search for a StatSignature.
    #
    # @return [void]
    def self.where(*)
      fail ESP::NotImplementedError
    end

    # Returns a paginated collection of region stats for the given stat_id
    # Convenience method to use instead of ::find since a stat_id is required to return region stats.
    #
    # @param stat_id [Integer, Numeric] Required ID of the stat to list region stats for.
    # @param options [Hash] Optional hash of options.
    #   ===== Valid Options
    #
    #   +include+ | The list of associated objects to return on the initial request.
    #
    #   ===== valid Includable Associations
    #
    #   See {API documentation}[http://api-docs.evident.io?ruby#stat-region-attributes] for valid arguments
    # @return [ActiveResource::PaginatedCollection<ESP::StatRegion>]
    # @example
    #   stats = ESP::StatRegion.for_stat(1194)
    def self.for_stat(stat_id = nil, options = {}) # rubocop:disable Style/OptionHash
      fail ArgumentError, "You must supply a stat id." unless stat_id.present?
      from = "#{prefix}stats/#{stat_id}/regions.json"
      find(:all, from: from, params: options)
    end

    # Find a StatRegion by id
    #
    # *call-seq* -> +super.find(id, options = {})+
    #
    # @overload find(id)
    #   @param id [Integer, Numeric] Required ID of the region stat to retrieve.
    #   @param options [Hash] Optional hash of options.
    #     ===== Valid Options
    #
    #     +include+ | The list of associated objects to return on the initial request.
    #
    #     ===== valid Includable Associations
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#stat-region-attributes] for valid arguments
    # @overload find(non_numeric, options = {})
    #   @param non_numeric [Object]
    #   @param options [Hash] +params: { stat_id: Integer }+
    # @return [ESP::StatRegion]
    def self.find(*arguments)
      scope = arguments.slice!(0)
      options = (arguments.slice!(0) || {}).with_indifferent_access
      return super(scope, options) if scope.is_a?(Numeric) || options[:from].present?
      params = options.fetch(:params, {}).with_indifferent_access
      stat_id = params.delete(:stat_id)
      for_stat(stat_id)
    end

    # @!method self.create
    # Not Implemented. You cannot create a Stat.
    #
    # @return [void]

    # @!method save
    # Not Implemented. You cannot create or update a Stat.
    #
    # @return [void]

    # @!method destroy
    # Not Implemented. You cannot delete a Stat.
    #
    # @return [void]

    # @!group 'total' rollup methods

    # @!method total

    # @!method total_pass

    # @!method total_fail

    # @!method total_warn

    # @!method total_error

    # @!method total_info

    # @!method total_new_1h_pass

    # @!method total_new_1h_fail

    # @!method total_new_1h_warn

    # @!method total_new_1h_error

    # @!method total_new_1h_info

    # @!method total_new_1d_pass

    # @!method total_new_1d_fail

    # @!method total_new_1d_warn

    # @!method total_new_1d_error

    # @!method total_new_1d_info

    # @!method total_new_1w_pass

    # @!method total_new_1w_fail

    # @!method total_new_1w_error

    # @!method total_new_1w_info

    # @!method total_new_1w_warn

    # @!method total_old_fail

    # @!method total_old_pass

    # @!method total_old_warn

    # @!method total_old_error

    # @!method total_old_info

    # @!method total_suppressed

    # @!method total_suppressed_pass

    # @!method total_suppressed_fail

    # @!method total_suppressed_warn

    # @!method total_suppressed_error

    # @!method total_new_1h

    # @!method total_new_1d

    # @!method total_new_1w

    # @!method total_old
  end
end
