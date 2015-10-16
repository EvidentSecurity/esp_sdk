module ESP
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

    # :method: create(attributes = {})
    # Create a contact request.
    #
    # ==== Attributes
    #
    # * +user_id+ - Required. The id of the user the request is for.
    # * +description+ - Required. A description of the request.
    # * +title+ - Required. The brief title/summary of the request.
    # * +request_type+ - Required. Valid values are support, feature.
    #
    # ==== Example
    #
    #   contact request = ESP::ContactRequest.create(user_id: 5, request_type: 'feature', title: 'My great feature idea', description: 'This is my idea for a really useful feature...')
  end
end
