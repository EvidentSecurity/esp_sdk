module ActiveResource
  module Validations
    # Loads the set of remote errors into the object's Errors based on the
    # content-type of the error-block received.
    def load_remote_errors(remote_errors, save_cache = false) #:nodoc:
      if self.class.format == ActiveResource::Formats::JsonAPIFormat
        errors.from_json_api(remote_errors.response.body, save_cache)
      elsif self.class.format == ActiveResource::Formats[:json]
        super
      end
    end
  end

  class Errors
    def from_json_api(json, save_cache = false)
      decoded = decoded_errors(json)
      errors = {}
      decoded.each do |error|
        errors.merge!(error['message']) if error['message']
      end
      if errors.present?
        from_hash errors, save_cache
      else
        from_array decoded.map { |e| e['title'] }
      end
    end

    private

    def decoded_errors(json)
      Array((Hash(ActiveSupport::JSON.decode(json)))['errors'])
    rescue
      []
    end
  end
end
