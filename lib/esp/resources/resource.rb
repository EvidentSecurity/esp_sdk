module ESP
  class Resource < ActiveResource::Base # :nodoc:
    self.site = ESP.site
    self.proxy = ESP.http_proxy
    self.format = ActiveResource::Formats::JsonAPIFormat
    puts "@@@@@@@@@ #{__FILE__}:#{__LINE__} \n********** ENV['ESP_ACCESS_KEY_ID'] = " + ENV['ESP_ACCESS_KEY_ID'].inspect
    puts "@@@@@@@@@ #{__FILE__}:#{__LINE__} \n********** ENV['ESP_SECRET_ACCESS_KEY'] = " + ENV['ESP_SECRET_ACCESS_KEY'].inspect
    puts "@@@@@@@@@ #{__FILE__}:#{__LINE__} \n********** ESP.access_key_id = " + ESP.access_key_id.inspect
    puts "@@@@@@@@@ #{__FILE__}:#{__LINE__} \n********** ESP.secret_access_key = " + ESP.secret_access_key.inspect
    with_api_auth(ESP.access_key_id, ESP.secret_access_key)
    headers["Content-Type"] = format.mime_type
    headers["User-Agent"] = "Ruby SDK #{ESP::VERSION}"

    self.collection_parser = ActiveResource::PaginatedCollection

    # List of predicates that can be used for searching
    PREDICATES = %w(sorts m eq eq_any eq_all not_eq not_eq_any not_eq_all matches matches_any matches_all does_not_match does_not_match_any does_not_match_all lt lt_any lt_all lteq lteq_any lteq_all gt gt_any gt_all gteq gteq_any gteq_all in in_any in_all not_in not_in_any not_in_all cont cont_any cont_all not_cont not_cont_any not_cont_all start start_any start_all not_start not_start_any not_start_all end end_any end_all not_end not_end_any not_end_all true false present blank null not_null).join('|').freeze

    # Pass a json api compliant hash to the api.
    def serializable_hash(*)
      h = attributes.extract!('included')
      h['data'] = { 'type' => self.class.to_s.underscore.sub('esp/', '').pluralize,
                    'attributes' => attributes.except('id', 'type', 'created_at', 'updated_at', 'relationships') }
      h['data']['id'] = id if id.present?
      h
    end

    def self.where(clauses = {})
      fail ArgumentError, "expected a clauses Hash, got #{clauses.inspect}" unless clauses.is_a? Hash
      from = clauses.delete(:from) || "#{prefix}#{name.demodulize.pluralize.underscore}"
      clauses = { params: clauses }
      arrange_options(clauses)
      prefix_options, query_options = split_options(clauses)
      instantiate_collection((format.decode(connection.put("#{from}.json", clauses[:params].to_json).body) || []), query_options, prefix_options).tap do |collection|
        make_pageable collection, clauses.merge(from: from)
      end
    end

    def self.find(*arguments)
      scope = arguments.slice!(0)
      options = (arguments.slice!(0) || {}).with_indifferent_access
      arrange_options(options)
      super(scope, options).tap do |object|
        make_pageable object, options
      end
    end

    def self.filters(params) # rubocop:disable Metrics/MethodLength
      h = {}.tap do |filters|
        params.each do |attr, value|
          unless attr =~ /(#{PREDICATES})$/
            attr = if value.is_a? Enumerable
                     "#{attr}_in"
                   else
                     "#{attr}_eq"
                   end
          end
          filters[attr] = value
        end
      end
      { filter: h }
    end

    def self.make_pageable(object, options = {}) # rubocop:disable Style/OptionHash
      options = options.with_indifferent_access
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
        include = options[:params][:include] ? { include: options[:params].delete(:include) } : {}
        options[:params].merge!(options[:params].delete(:filter)) if options[:params][:filter]
        options[:params] = filters(options[:params]).merge!(page).merge!(include)
      end
      if options[:include].present?
        options[:params] ||= {}
        options[:params].merge!(options.extract!(:include))
      end
    end
  end
end
