require 'active_support/json'

module ActiveResource
  module Formats
    module JsonAPIFormat
      extend self

      def extension
        "json"
      end

      def mime_type
        "application/vnd.api+json"
      end

      def encode(hash, options = nil)
        ActiveSupport::JSON.encode(hash, options)
      end

      def decode(json)
        Formats.remove_root(merge_included_objects(ActiveSupport::JSON.decode(json)))
      end

      private

      def merge_included_objects(elements)
        return elements unless included = elements.delete('included')
        elements.tap do |e|
          Array.wrap(e.fetch('data', {})).each do |object|
            object.fetch('links', {}).each do |assoc, links|
              linkage = links['linkage']
              object[assoc] = case linkage
                              when Array
                                included.select { |i| linkage.include?(i.slice('type', 'id')) }
                              when Hash
                                included.detect { |i| linkage == i.slice('type', 'id') }
                              else
                                nil
                              end
            end
          end
        end
      end
    end
  end
end
