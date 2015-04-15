module EspSdk
  class MissingAttribute < StandardError; end
  class UnknownAttribute < StandardError; end
  class TokenExpired < StandardError; end
  class RecordNotFound < StandardError; end
  class Exception < StandardError; end
  class Unauthorized < StandardError; end
end
