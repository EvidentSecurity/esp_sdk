require 'rack'

module ActiveResource
  class PaginatedCollection < ActiveResource::Collection
    attr_reader :next_page_params, :previous_page_params, :last_page_params
    attr_accessor :from

    def initialize(elements = [])
      # If a collection is sent without the pagination links, then elements will just be an array
      if elements.is_a? Hash
        super(elements['data'])
        parse_pagination_links(elements['links'])
      else
        super(elements)
      end
    end

    def parse_pagination_links(links)
      @next_page_params = links['next'] ? Rack::Utils.parse_nested_query(CGI.unescape(URI.parse(links['next']).query)) : {}
      @previous_page_params = links['prev'] ? Rack::Utils.parse_nested_query(CGI.unescape(URI.parse(links['prev']).query)) : {}
      @last_page_params = links['last'] ? Rack::Utils.parse_nested_query(CGI.unescape(URI.parse(links['last']).query)) : {}
      # The last page may not contain the full per page number of records, and will therefore come back with an incorrect size since the
      # size is based on the collection size.  This will mess up further calls to previous_page or first page so remove the size so it will bring back the default size.
      previous_page_params['page'].delete('size') if last_page? && previous_page_params['page']
    end

    def first_page
      previous_page? ? resource_class.all(from: from, params: { page: { number: 1 } }) : self
    end

    def first_page!
      first_page.tap { |page| update_self(page) }
    end

    def previous_page
      previous_page? ? resource_class.all(from: from, params: previous_page_params) : self
    end

    def previous_page!
      previous_page.tap { |page| update_self(page) }
    end

    def next_page
      next_page? ? resource_class.all(from: from, params: next_page_params) : self
    end

    def next_page!
      next_page.tap { |page| update_self(page) }
    end

    def last_page
      !last_page? ? resource_class.all(from: from, params: last_page_params) : self
    end

    def last_page!
      last_page.tap { |page| update_self(page) }
    end

    def page(page_number = nil)
      fail ArgumentError, "You must supply a page number." unless page_number.present?
      fail ArgumentError, "Page number cannot be less than 1." if page_number.to_i < 1
      fail ArgumentError, "Page number cannot be greater than the last page number." if page_number.to_i > last_page_number.to_i
      page_number.to_i != current_page_number.to_i ? resource_class.all(from: from, params: { page: { number: page_number, size: (next_page_params || previous_page_params)['page']['size'] } }) : self
    end

    def page!(page_number)
      page(page_number).tap { |page| update_self(page) }
    end

    def current_page_number
      (previous_page_number.to_i + 1).to_s
    end

    def previous_page_number
      Hash(previous_page_params).fetch('page', {}).fetch('number', nil)
    end

    def next_page_number
      Hash(next_page_params).fetch('page', {}).fetch('number', nil)
    end

    def last_page_number
      Hash(last_page_params).fetch('page', {}).fetch('number', nil)
    end

    def previous_page?
      !previous_page_number.nil?
    end

    def next_page?
      !next_page_number.nil?
    end

    def last_page?
      last_page_number.nil?
    end

    private

    def update_self(page)
      @elements = page.elements
      @next_page_params = page.next_page_params
      @previous_page_params = page.previous_page_params
      @last_page_params = page.last_page_params
    end
  end
end
