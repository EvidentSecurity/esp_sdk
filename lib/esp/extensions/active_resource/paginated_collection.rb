require 'rack'

module ActiveResource
  class PaginatedCollection < ActiveResource::Collection
    # Internal variable used to construct queries.
    # @return [Hash]
    # @private
    attr_reader :next_page_params, :previous_page_params, :last_page_params
    # Internal variable used to construct queries.
    # @return [Integer]
    # @private
    attr_accessor :from

    # @private
    def initialize(elements = [])
      # If a collection is sent without the pagination links, then elements will just be an array.
      if elements.is_a? Hash
        super(elements['data'])
        parse_pagination_links(elements['links'])
      else
        super(elements)
      end
    end

    # Returns the first page of results.
    #
    # Returns +self+ (and no API call is made) when already on the first page.
    #
    # @return [PaginatedCollection, self]
    # @example
    #   alerts.current_page_number # => 5
    #   first_page = alerts.first_page
    #   alerts.current_page_number # => 5
    #   first_page.current_page_number # => 1
    def first_page
      previous_page? ? updated_collection(from: from, page: { number: 1 }) : self
    end

    # Updates the existing PaginatedCollection object with the first page of data when not on the first page.
    #
    # @return (see #first_page)
    # @example
    #   alerts.current_page_number # => 5
    #   alerts.first_page!
    #   alerts.current_page_number # => 1
    def first_page!
      first_page.tap { |page| update_self(page) }
    end

    # Returns the previous page of results.
    #
    # Returns +self+ (and no API call is made) when already on the first page.
    #
    # @return [PaginatedCollection, self]
    # @example
    #   alerts.current_page_number # => 5
    #   previous_page = alerts.previous_page
    #   alerts.current_page_number # => 5
    #   previous_page.current_page_number # => 4
    def previous_page
      previous_page? ? updated_collection(previous_page_params.merge(from: from)) : self
    end

    # Updates the existing PaginatedCollection object with the previous page of data when not on the first page.
    #
    # @return (see #previous_page)
    # @example
    #   alerts.current_page_number # => 5
    #   alerts.previous_page!
    #   alerts.current_page_number # => 4
    def previous_page!
      previous_page.tap { |page| update_self(page) }
    end

    # Returns the next page of results.
    #
    # Returns +self+ (and no API call is made) when already on the last page.
    #
    # @return [PaginatedCollection, self]
    # @example
    #   alerts.current_page_number # => 5
    #   next_page = alerts.next_page
    #   alerts.current_page_number # => 5
    #   next_page.current_page_number # => 6
    def next_page
      next_page? ? updated_collection(next_page_params.merge(from: from)) : self
    end

    # Updates the existing PaginatedCollection object with the last page of data when not on the last page.
    #
    # @return (see #next_page)
    # @example
    #   alerts.current_page_number # => 5
    #   alerts.next_page!
    #   alerts.current_page_number # => 6
    def next_page!
      next_page.tap { |page| update_self(page) }
    end

    # Returns the last page of results.
    #
    # Returns +self+ (and no API call is made)  when already on the last page.
    #
    # @return [PaginatedCollection, self]
    # @example
    #   alerts.current_page_number # => 5
    #   last_page = alerts.last_page
    #   alerts.current_page_number # => 5
    #   last_page.current_page_number # => 25
    def last_page
      !last_page? ? updated_collection(last_page_params.merge(from: from)) : self
    end

    # Updates the existing PaginatedCollection object with the last page of data when not on the last page.
    #
    # @return (see #last_page)
    # @example
    #   alerts.current_page_number # => 5
    #   alerts.last_page!
    #   alerts.current_page_number # => 25
    def last_page!
      last_page.tap { |page| update_self(page) }
    end

    # Returns the +page_number+ page of data.
    #
    # Returns +self+ when +page_number+ == +#current_page_number+
    #
    # @param page_number [Integer] The page number of the data wanted. Must be between 1 and +#last_page_number+.
    # @return [PaginatedCollection, self]
    # @raise [ArgumentError] if no page number or an out-of-bounds page number is supplied.
    # @example
    #   alerts.current_page_number # => 5
    #   page = alerts.page(2)
    #   alerts.current_page_number # => 5
    #   page.current_page_number # => 2
    def page(page_number = nil)
      fail ArgumentError, "You must supply a page number." unless page_number.present?
      fail ArgumentError, "Page number cannot be less than 1." if page_number.to_i < 1
      fail ArgumentError, "Page number cannot be greater than the last page number." if page_number.to_i > last_page_number.to_i
      page_number.to_i != current_page_number.to_i ? updated_collection(from: from, page: { number: page_number, size: (next_page_params || previous_page_params)['page']['size'] }) : self
    end

    # Returns a new PaginatedCollection with the +page_number+ page of data when not already on page +page_number+.
    #
    # @param (see #page)
    # @return (see #page)
    # @example
    #   alerts.current_page_number # => 5
    #   alerts.page!(2)
    #   alerts.current_page_number # => 2
    def page!(page_number)
      page(page_number).tap { |page| update_self(page) }
    end

    # The current page number of data.
    #
    # @return [String]
    def current_page_number
      (previous_page_number.to_i + 1).to_s
    end

    # The previous page number of data.
    #
    # @return [String, nil]
    def previous_page_number
      Hash(previous_page_params).fetch('page', {}).fetch('number', nil)
    end

    # The next page number of data.
    #
    # @return [String, nil]
    def next_page_number
      Hash(next_page_params).fetch('page', {}).fetch('number', nil)
    end

    # The last page number of data.
    #
    # @return [String, nil]
    def last_page_number
      Hash(last_page_params).fetch('page', {}).fetch('number', nil)
    end

    # Returns whether or not there is a previous page of data in the collection.
    #
    # @return [Boolean]
    def previous_page?
      !previous_page_number.nil?
    end

    # Returns whether or not there is a next page of data in the collection.
    #
    # @return [Boolean]
    def next_page?
      !next_page_number.nil?
    end

    # Returns whether or not the collection is on the last page.
    #
    # @return [Boolean]
    def last_page?
      last_page_number.nil?
    end

    private

    # Start a new collection.
    #
    # @param params [Hash]
    # @return [PaginatedCollection]
    def updated_collection(params)
      resource_class.where(original_params.merge(params))
    end

    def update_self(page)
      @elements = page.elements
      @next_page_params = page.next_page_params
      @previous_page_params = page.previous_page_params
      @last_page_params = page.last_page_params
    end

    def parse_pagination_links(links)
      @next_page_params = links['next'] ? Rack::Utils.parse_nested_query(CGI.unescape(URI.parse(links['next']).query)) : {}
      @previous_page_params = links['prev'] ? Rack::Utils.parse_nested_query(CGI.unescape(URI.parse(links['prev']).query)) : {}
      @last_page_params = links['last'] ? Rack::Utils.parse_nested_query(CGI.unescape(URI.parse(links['last']).query)) : {}
      # The last page may not contain the full per page number of records, and will therefore come back with an incorrect size since the
      # size is based on the collection size.  This will mess up further calls to previous_page or first page so remove the size so it will bring back the default size.
      previous_page_params['page'].delete('size') if last_page? && previous_page_params['page']
    end
  end
end
