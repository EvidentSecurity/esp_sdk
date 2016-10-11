module Dirty
  def original_attributes
    @original_attributes ||= {}.with_indifferent_access
  end

  def original_attributes=(attributes = {})
    @original_attributes = attributes.dup
  end

  def changed_attributes
    attributes.select do |key, value|
      next if value == original_attributes[key]
      true
    end
  end
end

# Set the original attributes every time we instantiate an object from the api
# This happens on GET requests
module InstantiateWithOriginalAttributes
  private

  def instantiate_record(record, _prefix_options = {})
    super(record, _prefix_options = {}).tap do |object|
      object.original_attributes = object.attributes
    end
  end
end

module LoadWithOriginalAttributes
  # After sending to the API the object is reloaded with its attributes
  # The persisted flag tells us it has been saved
  def load(attributes, _remove_root = false, persisted = false)
    if persisted
      super.tap do |object|
        object.original_attributes = object.attributes
      end
    else
      super
    end
  end
end

class ActiveResource::Base
  include Dirty
  prepend LoadWithOriginalAttributes

  class << self
    prepend InstantiateWithOriginalAttributes
  end
end
