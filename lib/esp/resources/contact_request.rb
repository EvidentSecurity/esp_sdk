module ESP
  # Use contact requests to send a support or feature request to Evident.io.
  class ContactRequest < ESP::Resource
    # Not Implemented. You cannot search for ContactRequest.
    #
    # @return [void]
    def self.find(*)
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot search for ContactRequest.
    #
    # @return [void]
    def self.where(*)
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot update a ContactRequest.
    #
    # @return [void]
    def update
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a ContactRequest.
    #
    # @return [void]
    def destroy
      fail ESP::NotImplementedError
    end

    # @!method self.create(attributes={})
    #   Create a contact request.
    #
    #   *call-seq* -> +create(attributes={})+
    #
    #   @param attributes [Hash] Required hash of contact request attributes
    #     ===== Valid Attributes
    #
    #     See {API documentation}[http://api-docs.evident.io?ruby#contact-request-create] for valid arguments
    #   @return [ESP::ContactRequest]
    #   @example
    #     contact_request = ESP::ContactRequest.create(request_type: 'feature', title: 'My great feature idea', description: 'This is my idea for a really useful feature...')
    #
  end
end
