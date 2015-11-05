require 'active_support/json'

module ActiveResource
  class ConnectionError
    def initialize(response)
      @response = if response.respond_to?(:response)
                    message = decoded_errors(response.response.body)
                    Struct.new(:body, :code, :message).new(response.response.body, response.code, message)
                  else
                    response
                  end
    end

    private

    def decoded_errors(json)
      Array((Hash(ActiveSupport::JSON.decode(json)))['errors'].map { |e| e['title'] }).join(" ")
    rescue
      []
    end
  end

  module Formats
    module JsonAPIFormat
      module_function

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
        # ap ActiveSupport::JSON.decode(json), index: false, indent: -2
        Formats.remove_root(parse_json_api(ActiveSupport::JSON.decode(json)))
      end

      private

      def self.parse_json_api(elements)
        included = elements.delete('included')
        elements.tap do |e|
          Array.wrap(e.fetch('data', {})).each do |object|
            parse_object!(object, included)
          end
        end
      end

      def self.parse_object!(object, included = nil)
        return object unless object.respond_to?(:each)
        merge_attributes!(object)
        parse_elements(object)
        parse_relationships!(object, included)
        object
      end

      def self.parse_elements(object)
        object.each_value do |value|
          if value.is_a? Hash
            parse_object!(value)
          elsif value.is_a? Array
            value.map! { |o| parse_object!(o) }
          end
        end
      end

      def self.parse_relationships!(object, included)
        object.fetch('relationships', {}).each do |assoc, details|
          extract_foreign_keys!(object, assoc, details['data'])
          merge_included_objects!(object, assoc, details['data'], included)
        end
      end

      def self.merge_attributes!(object)
        return unless object.is_a? Hash
        object.merge! object.delete('attributes') unless object['attributes'].blank?
      end

      def self.extract_foreign_keys!(object, assoc, data)
        return if data.blank?
        if data.is_a? Array
          object["#{assoc.singularize}_ids"] = data.map { |d| d['id'] }
        else
          object["#{assoc}_id"] = data['id']
        end
      end

      def self.merge_included_objects!(object, assoc, data, included)
        return if included.blank?
        object[assoc] = case data
                        when Array
                          included.select { |i| data.include?(parse_object!(i).slice('type', 'id')) }
                        when Hash
                          included.detect { |i| data == parse_object!(i).slice('type', 'id') }
                        end
      end
    end
  end
end
