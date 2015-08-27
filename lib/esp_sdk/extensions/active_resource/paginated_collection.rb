module ActiveResource
  class PaginatedCollection < ActiveResource::Collection
    attr_reader :next_page_number, :previous_page_number, :total_pages
    attr_accessor :from

    def initialize(elements = [])
      # If a collection is sent without the pagination links, then elements will just be an array
      if elements.is_a? Hash
        links = elements['links']
        super(elements['data'])
        @next_page_number = links['next'].scan(/page=(\d+)/).first.first if links['next']
        @previous_page_number = links['prev'].scan(/page=(\d+)/).first.first if links['prev']
        @total_pages = links['last'].scan(/page=(\d+)/).first.first if links['last']
      else
        super(elements)
        @total_pages = 1
      end
    end

    def first_page
      previous_page? ? resource_class.all(params: { page: 1 }) : self
    end

    def first_page!
      first_page.tap { |page| update_self(page) }
    end

    def previous_page
      page = previous_page? ? resource_class.all(params: { page: previous_page_number }) : self
    end

    def previous_page!
      previous_page.tap { |page| update_self(page) }
    end

    def next_page
      page = next_page? ? resource_class.all(from: from, params: { page: next_page_number }) : self
    end

    def next_page!
      next_page.tap { |page| update_self(page) }
    end

    def last_page
      page = (total_pages && next_page?) ? resource_class.all(params: { page: total_pages }) : self
    end

    def last_page!
      last_page.tap { |page| update_self(page) }
    end

    def previous_page?
      !previous_page_number.nil?
    end

    def next_page?
      !next_page_number.nil?
    end

    def current_page_number
      previous_page_number.to_i + 1
    end

    private

    def update_self(page)
      @elements = page.elements
      @next_page_number = page.next_page_number
      @previous_page_number = page.previous_page_number
    end
  end
end
