module ESP
  class ContactRequest < ESP::Resource
    belongs_to :user, class_name: 'ESP::User'
  end
end
