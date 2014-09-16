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
    def show(params={})
      run_callbacks(:validate_id, params) { submit(id_url(params.delete(:id)), :Get) }
    end

    # Update a single record
    def update(params={})
      run_callbacks(:validate_id, :validate_update_params, params) { submit(id_url(params.delete(:id)), :Patch, params) }
    end

    # Destroy a single record
    def destroy(params={})
      run_callbacks(:validate_id, params) { submit(id_url(params.delete(:id)), :Delete) }
    end
    
    # Create a new record
    def create(params={})
      run_callbacks(:validate_create_params, params) { submit(base_url, :Post, params) }
    end

    private

      def validate_id(params)
        raise EspSdk::Exceptions::MissingAttribute, 'Missing required attribute id' if params[:id].blank?
      end

      # Validate update params
      def validate_update_params(params)
        # We allow for single field update so we do not need to check every required param here.
        # Check for params that are not valid instead.
        valid = valid_params + required_params
        params.keys.each do |key|
          raise EspSdk::Exceptions::UnknownAttribute, key unless valid.include?(key)
        end
      end

      # Validate the create params
      def validate_create_params(params)
        # Check for missing required params
        # ID is not a valid create param
        (required_params - [:id]).each do |param|
          raise EspSdk::Exceptions::MissingAttribute, "Missing required attribute #{param}" if params[param].blank?
        end

        # Remove ID from valid params. Include the required params as valid params
        valid = ((valid_params + required_params).uniq - [:id])

        # Check for params that are not valid
        params.keys.each do |key|
          raise EspSdk::Exceptions::UnknownAttribute, key unless valid.include?(key)
        end
      end

      # Override in the sub class should return an array of symbols that represent valid required params for the model
      def required_params
        []
      end

      # Override in the sub class should return an array of symbols that represent valid params for the model
      def valid_params
        []
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

      # Run the callbacks defined for parameter checking.
      def run_callbacks(*args)
        # Last arg is the params
        params = args.pop

        # Go through and call our callbacks
        args.each do |callback|
          send(callback, params)
        end

        # Yield block if given.
        yield if block_given?
      end
  end
end