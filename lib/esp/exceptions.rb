module ESP
  class MissingAttribute < StandardError; end
  class UnknownAttribute < StandardError; end
  class TokenExpired < StandardError; end
  class RecordNotFound < StandardError; end
  class Exception < StandardError; end
  class Unauthorized < StandardError; end
  class NotImplemented < StandardError; end
end

module EspSdk # For backward compatibility with V1.
  class TokenExpired < StandardError; end
end
