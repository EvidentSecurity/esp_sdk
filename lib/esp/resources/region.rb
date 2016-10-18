module ESP
  class Region < ESP::Resource
    # Not Implemented. You cannot create or update a Region.
    #
    # @return [void]
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a an Region.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # Create a suppression for this region.
    #
    # @param arguments [Hash] Required hash of region suppression attributes.
    #   ===== Valid Arguments
    #
    #   See {API documentation}[http://api-docs.evident.io?ruby#suppression-create] for valid arguments
    # @return [ESP::Suppression::Region]
    # @example
    #   suppress(external_account_ids: [5], reason: 'My very good reason for creating this suppression')
    def suppress(arguments = {})
      arguments = arguments.with_indifferent_access
      ESP::Suppression::Region.create(regions: [code], external_account_ids: Array(arguments[:external_account_ids]), reason: arguments[:reason])
    end

    # @!method self.where(clauses = {})
    #   Return a paginated Region list filtered by search parameters
    #
    #   *call-seq* -> +super.where(clauses = {})+
    #
    #   @param clauses [Hash] A hash of attributes with appended predicates to search and sort by.
    #     ===== Valid Clauses
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#region-attributes] for valid arguments
    #   @return [ActiveResource::PaginatedCollection<ESP::Region>]

    # @!method self.find(id)
    #   Find a Region by id
    #
    #   *call-seq* -> +super.find(id)+
    #
    #   @param id [Integer, Numeric, #to_i] Required ID of the region to retrieve.
    #   @return [ESP::Region]

    # @!method self.all
    #   Return a paginated list.
    #
    #   @return [ActiveResource::PaginatedCollection<ESP::Region>]
  end
end
