require 'json'

module EspSdk
  class Base < EspSdk::Client
    attr_reader :current_page, :current_record

    def next_page
      if @current_page
        if @page_links['next'].present?
          response = connect(@page_links['next'], :get)
          pagination_links(response)
          @current_page = JSON.load(response.body)
        else
          @current_page
        end
      else
        list
      end
    end

    def prev_page
      if @current_page
        if @page_links['prev'].present?
          response      = connect(@page_links['prev'], :get)
          pagination_links(response)
          @current_page = JSON.load(response.body)
        else
          @current_page
        end
      else
        list
      end
    end

    # Get a pageable list of records
    def list
      response = connect(base_url, :get)
      pagination_links(response)
      @current_page = JSON.load(response.body)
    end

    # Get a single record
    def show(params = {})
      validate_id(params)
      submit(id_url(params.delete(:id)), :get)
    end

    # Update a single record
    def update(params = {})
      validate_id(params)
      submit(id_url(params.delete(:id)), :patch, params)
    end

    # Destroy a single record
    def destroy(params = {})
      validate_id(params)
      submit(id_url(params.delete(:id)), :delete)
    end

    # Create a new record
    def create(params = {})
      submit(base_url, :post, params)
    end

    private

    def validate_id(params)
      fail ::MissingAttribute, 'Missing required attribute id' if params[:id].blank?
    end

    def id_url(id)
      "#{config.uri}/#{config.version}/#{self.class.to_s.demodulize.underscore}/#{id}"
    end

    def base_url
      "#{config.uri}/#{config.version}/#{self.class.to_s.demodulize.underscore}"
    end

    def submit(url, type, options = {})
      response         = connect(url, type, options)
      @current_record  = JSON.load(response.body)
    end

    def pagination_links(response)
      @page_links = JSON.load(response.headers[:link])
    end
  end
end
