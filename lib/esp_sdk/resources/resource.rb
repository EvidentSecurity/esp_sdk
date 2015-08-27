module ESP
  class Resource < ActiveResource::Base
    self.site = "http://localhost:3000/api/v2"
    self.format = ActiveResource::Formats::JsonAPIFormat
    with_api_auth(ESP::Credentials.access_key_id, ESP::Credentials.secret_access_key)
    headers["Content-Type"] = "application/vnd.api+json"

    self.collection_parser = ActiveResource::PaginatedCollection

    def load(*)
      super
      add_foreign_keys
    end

    # Pass a json_api compliant hash to the api.
    def serializable_hash(*)
      { 'data' => { 'type' => self.class.to_s.demodulize.underscore.pluralize,
                    'attributes' => attributes.except('id', 'type', 'created_at', 'updated_at', 'links') } }.tap do |h|
        h['data']['id'] = id unless new?
      end
    end

    private

    def add_foreign_keys
      return unless attributes['links'].present?
      attributes['links'].attributes.each do |assoc, object|
        unless object.linkage.is_a? Array
          attributes["#{assoc}_id"] = object.linkage.try(:id)
        end
      end
    end
  end
end
