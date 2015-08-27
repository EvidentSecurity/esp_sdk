require 'json'

module ESP
  class Base < ESP::Client
    attr_reader :current_page, :current_record

    def next_page
      return list if current_page.blank?

      if @page_links['next'].present?
        response = connect(@page_links['next'], :get)
        pagination_links(response)
        self.current_page = JSON.load(response.body)
      else
        @current_page
      end
    end

    def prev_page
      return list if current_page.blank?

      if @page_links['prev'].present?
        response = connect(@page_links['prev'], :get)
        pagination_links(response)
        self.current_page = JSON.load(response.body)
      else
        @current_page
      end
    end

    # Get a pageable list of records
    def list
      response = connect(base_url, :get)
      pagination_links(response)
      self.current_page = JSON.load(response.body)
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
      fail MissingAttribute, 'Missing required attribute id' if params[:id].blank?
    end

    def id_url(id)
      "#{base_url}/#{id}"
    end

    def base_url
      config.url(self.class.to_s.demodulize.underscore)
    end

    def submit(url, type, options = {})
      response = connect(url, type, options)
      @current_record = ActiveSupport::HashWithIndifferentAccess.new(JSON.load(response.body))
    end

    # Converts the link header into a hash of links
    #
    # "<http://test.host/api/v1/custom_signatures?page=2>; rel=\"last\", <http://test.host/api/v1/custom_signatures?page=2>; rel=\"next\""
    # => { "last" => "http://test.host/api/v1/custom_signatures?page=2",
    #      "next" => "http://test.host/api/v1/custom_signatures?page=2" }
    def pagination_links(response)
      @page_links = ActiveSupport::HashWithIndifferentAccess.new(JSON.load(response.headers[:link]))
    rescue JSON::ParserError
      @page_links = ActiveSupport::HashWithIndifferentAccess.new.tap do |page_links|
        response.headers[:link].to_s.split(',').each do |link|
          /<(?<link>.*)>; rel="(?<key>\w*)"/ =~ link
          page_links[key] = link
        end
      end
    end

    def current_page=(values)
      @current_page = values.map(&:with_indifferent_access)
    end
  end
end
