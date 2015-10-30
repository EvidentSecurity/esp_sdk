module ESP
  # Use contact requests to send a support or feature request to Evident.io.
  class ContactRequest < ESP::Resource
    # Not Implemented. You cannot search for ContactRequest.
    def self.find(*)
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot update a ContactRequest.
    def update
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a ContactRequest.
    def destroy
      fail ESP::NotImplementedError
    end

    # :method: create(attributes={})
    # Create a contact request.
    #
    # ==== Parameter
    #
    # +attributes+ | Required | A hash of contact request attributes
    #
    # ===== Valid Attributes
    #
    # +title+ | Required | Subject of your message
    #
    # +description+ | Required | Body of your message
    #
    # +request_type+ | Required | Type of contact request. Supported values are `support` for support requests and `feature` for a feature request
    #
    #
    # :call-seq:
    #  create(attributes={})
    #
    # ==== Example
    #
    #   contact_request = ESP::ContactRequest.create(request_type: 'feature', title: 'My great feature idea', description: 'This is my idea for a really useful feature...')
  end
end
