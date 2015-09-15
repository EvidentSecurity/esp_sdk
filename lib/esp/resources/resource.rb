module ESP
  class Resource < ActiveResource::Base
    self.site = ESP::SITE[ESP.env.to_sym]
    self.format = ActiveResource::Formats::JsonAPIFormat
    with_api_auth(ESP::Credentials.access_key_id, ESP::Credentials.secret_access_key)
    headers["Content-Type"] = self.format.mime_type

    self.collection_parser = ActiveResource::PaginatedCollection

    # Pass a json_api compliant hash to the api.
    def serializable_hash(*)
      { 'data' => { 'type' => self.class.to_s.demodulize.underscore.pluralize,
                    'attributes' => attributes.except('id', 'type', 'created_at', 'updated_at', 'links') } }.tap do |h|
        h['data']['id'] = id unless new?
      end
    end
  end
end
