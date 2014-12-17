require 'json'

module EspSdk
  module EndPoints
    class Base < EspSdk::Client
      attr_reader :current_page, :current_record

      def next_page
        return list if current_page.blank?

        if @page_links['next'].present?
          response = connect(@page_links['next'], :get)
          pagination_links(response)
          self.current_page = JSON.load(response.body)
        else
          current_page
        end
      end

      def prev_page
        return list if current_page.blank?

        if @page_links['prev'].present?
          response      = connect(@page_links['prev'], :get)
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
        "#{config.uri}/#{config.version}/#{self.class.to_s.demodulize.underscore}"
      end

      def submit(url, type, options = {})
        response         = connect(url, type, options)
        @current_record  = ActiveSupport::HashWithIndifferentAccess.new(JSON.load(response.body))
      end

      def pagination_links(response)
        @page_links = ActiveSupport::HashWithIndifferentAccess.new(JSON.load(response.headers[:link]))
      end

      def current_page=(value)
        @current_page = ActiveSupport::HashWithIndifferentAccess.new(value)
      end
    end
  end
end
