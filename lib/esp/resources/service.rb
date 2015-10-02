module ESP
  class Service < ESP::Resource
    has_many :signatures, class_name: 'ESP::Signature'

    def create
      fail ESP::NotImplementedError
    end

    def destroy
      fail ESP::NotImplementedError
    end
  end
end
