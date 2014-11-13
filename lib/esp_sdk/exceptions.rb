module EspSdk
  class MissingAttribute < ArgumentError; end
  class UnknownAttribute < ArgumentError; end
  class TokenExpired     < StandardError; end
  class RecordNotFound   < StandardError; end
end
