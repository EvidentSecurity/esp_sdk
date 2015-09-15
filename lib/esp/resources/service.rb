module ESP
  class Service < ESP::Resource
    has_many :signatures, class_name: 'ESP::Signature'

    def create
      fail ESP::NotImplemented
    end

    def destroy
      fail ESP::NotImplemented
    end
  end
end
