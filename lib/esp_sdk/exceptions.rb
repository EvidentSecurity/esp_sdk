module EspSdk
  module Exceptions
    class MissingAttribute < ArgumentError; end
    class UnknownAttribute < ArgumentError; end
    class TokenExpired     < Exception; end
    class RecordNotFound   < Exception; end
  end
end