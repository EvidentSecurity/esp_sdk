module ESP
  class Suppression < ESP::Resource
    belongs_to :organization, class_name: 'ESP::Organization'
    belongs_to :created_by, class_name: 'ESP::User'

    def deactivate!
      patch(:deactivate)
      self.class.find(id)
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid => error
      self.class.new.tap { |suppression| suppression.load_remote_errors(error, true) }
    end

    def save
      fail ESP::NotImplemented
    end

    def destroy
      fail ESP::NotImplemented
    end
  end
end
