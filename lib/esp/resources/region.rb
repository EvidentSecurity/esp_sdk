module ESP
  class Region < ESP::Resource
    # Not Implemented. You cannot create or update a CloudTrailEvent.
    def save
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a an CloudTrailEvent.
    def destroy
      fail ESP::NotImplementedError
    end

    # Create a suppression for this region.
    #
    # ==== Parameter
    #
    # +arguments+ | Required | A hash of region suppression attributes
    #
    # ===== Valid Arguments
    #
    # +external_account_ids+ | Required | An Array of the external accounts identified by +external_account_id+ to suppress the signature or custom signature on.
    #
    # +reason+ | Required | The reason for creating the suppression.
    #
    # ==== Example
    #   suppress(external_account_ids: [5], reason: 'My very good reason for creating this suppression')
    def suppress(arguments = {})
      arguments = arguments.with_indifferent_access
      ESP::Suppression::Region.create(regions: [code], external_account_ids: Array(arguments[:external_account_ids]), reason: arguments[:reason])
    end

    # :singleton-method: where
    # Return a paginated Region list filtered by search parameters
    #
    # ==== Parameters
    #
    # +clauses+ | Hash of attributes with appended predicates to search and sort by.
    #
    # ===== Valid Equality Searchable Attributes
    #
    # +id+
    #
    # +code+
    #
    # ===== Valid Matching Searchable Attributes
    #
    # +code+
    #
    # :call-seq:
    #  where(clauses = {})

    ##
    # :singleton-method: find
    # Find a Region by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the region to retrieve
    #
    # :call-seq:
    #  find(id)

    # :singleton-method: all
    # Return a paginated Region list
  end
end
