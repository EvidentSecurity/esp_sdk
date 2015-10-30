module ESP
  class Resource < ActiveResource::Base # :nodoc:
    self.site = ESP.site
    self.format = ActiveResource::Formats::JsonAPIFormat
    with_api_auth(ESP.access_key_id, ESP.secret_access_key)
    headers["Content-Type"] = format.mime_type

    self.collection_parser = ActiveResource::PaginatedCollection

    def self.where(*)
      fail ESP::NotImplementedError
    end

    # Pass a json api compliant hash to the api.
    def serializable_hash(*)
      h = attributes.extract!('included')
      h['data'] = { 'type' => self.class.to_s.underscore.sub('esp/','').pluralize,
                    'attributes' => attributes.except('id', 'type', 'created_at', 'updated_at', 'relationships') }
      h['data']['id'] = id if id.present?
      h
    end

    def self.find(*arguments)
      scope = arguments.slice!(0)
      options = (arguments.slice!(0) || {}).with_indifferent_access
      arrange_options(options)
      super(scope, options).tap do |object|
        make_pageable object, options
      end
    end

    def self.filters(params)
      h = {}.tap do |filters|
        params.each do |attr, value|
          if value.is_a? Enumerable
            filters["#{attr.sub(/_in$/, '')}_in"] = value
          else
            filters["#{attr.sub(/_eq$/, '')}_eq"] = value
          end
        end
      end
      { filter: h }
    end

    def self.make_pageable(object, options)
      return object unless object.is_a? ActiveResource::PaginatedCollection
      # Need to set from so paginated collection can use it for page calls.
      object.tap do |collection|
        collection.from = options['from']
        collection.original_params = options['params']
      end
    end

    def self.arrange_options(options)
      if options[:params].present?
        page = options[:params][:page] ? { page: options[:params].delete(:page) } : {}
        options[:params].merge!(options[:params].delete(:filter)) if options[:params][:filter]
        options[:params] = filters(options[:params]).merge!(page)
      end
      if options[:include].present?
        options[:params] ||= {}
        options[:params].merge!(options.extract!(:include))
      end
    end
  end
end
