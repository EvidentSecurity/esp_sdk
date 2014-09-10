require 'json'

module EspSdk
  class Base < EspSdk::Client
    attr_accessor :page_number
    attr_reader :current_page, :total_pages, :current_record
    
    def pages
      @pages ||= {}
    end

    def page_number
      @page_number ||= 0
    end

    def next_page
      # Call list first if @current_page is blank
      list if @current_page.blank?

      pages[self.page_number.to_s] ||= @current_page
      self.page_number += 1

      if self.page_number <= (@page_links.length - 1)
        if pages[self.page_number.to_s].present?
          @current_page = pages[self.page_number.to_s]
        else
          @current_page = Client.convert_json(connect(@page_links[self.page_number], :Get).body)
        end
      else
        self.page_number -= 1
        @current_page
      end
    end

    def prev_page
      # Call list first if @current_page is blank
      list if @current_page.blank?

      self.page_number -= 1

      if self.page_number >= 0 && pages[self.page_number.to_s].present?
        @current_page = pages[self.page_number.to_s]
      else
        self.page_number += 1
        @current_page
      end
    end

    # Get a pageable list of records
    def list
      response      = connect(base_url, :Get)
      @page_links   = pagination_links(response)
      @total_pages  = @page_links.count
      @current_page = Client.convert_json(response.body)
    end

    # Get a single record
    def show(options={})
      check_id(options)
      submit(id_url(options.delete(:id)), :Get)
    end

    # Update a single record
    def update(options={})
      check_id(options)
      submit(id_url(options.delete(:id)), :Patch, options)
    end

    # Destroy a single record
    def destroy(options={})
      check_id(options)
      submit(id_url(options.delete(:id)), :Delete)
    end
    
    # Create a new record
    def create(options={})
      submit(base_url, :Post, options)
    end

    private

      def check_id(options)
        raise EspSdk::Exceptions::MissingAttribute, 'Missing required attribute id:' unless options[:id].present?
      end

      def id_url(id)
        "#{config.uri}/#{config.version}/#{self.class.to_s.demodulize.underscore}/#{id}"
      end
    
      def base_url
        "#{config.uri}/#{config.version}/#{self.class.to_s.demodulize.underscore}"
      end
    
      def submit(url, type, options={})
        response         = connect(url, type, options)
        @current_record  = Client.convert_json(response.body)
      end

      def pagination_links(response)
        response['Link'].to_s.scan(/https?:\/\/[\w.:\/?=]+/)
      end
  end
end