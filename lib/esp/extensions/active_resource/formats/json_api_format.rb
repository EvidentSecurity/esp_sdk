require 'active_support/json'

module ActiveResource
  module Formats
    module JsonAPIFormat
      extend self

      def extension
        "json".freeze
      end

      def mime_type
        "application/vnd.api+json".freeze
      end

      def encode(hash, options = nil)
        ActiveSupport::JSON.encode(hash, options)
      end

      def decode(json)
        Formats.remove_root(parse_json_api(ActiveSupport::JSON.decode(json)))
      end

      private

      def parse_json_api(elements)
        included = elements.delete('included')
        elements.tap do |e|
          Array.wrap(e.fetch('data', {})).each do |object|
            parse_object!(object, included)
          end
        end
      end

      def parse_object!(object, included = nil)
        merge_attributes!(object)
        object.fetch('relationships', {}).each do |assoc, details|
          extract_foreign_keys!(object, assoc, details['data'])
          merge_included_objects!(object, assoc, details['data'], included)
        end
        object
      end

      def merge_attributes!(object)
        return if object['attributes'].blank?
        object.merge! object.delete('attributes')
      end

      def extract_foreign_keys!(object, assoc, data)
        return if data.blank?
        object["#{assoc}_id"] = data['id'] unless data.is_a? Array
      end

      def merge_included_objects!(object, assoc, data, included)
        return if included.blank?
        object[assoc] = case data
                        when Array
                          included.select { |i| data.include?(parse_object!(i).slice('type', 'id')) }
                        when Hash
                          included.detect { |i| data == parse_object!(i).slice('type', 'id') }
                        else
                          nil
                        end
      end
    end
  end
end
