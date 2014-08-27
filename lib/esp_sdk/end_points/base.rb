require 'json'

module EspSdk
  class Base < EspSdk::Client
    attr_accessor :page_number
    attr_reader :current_page, :total_pages, :current_record

    def pages
      @pages ||= {}
    end

    def page_number
      @page_number || 0
    end

    def pagination_links(response)
      response['Link'].to_s.scan(/https?:\/\/[\w.:\/?=]+/)
    end


    def next_page
      pages[self.page_number.to_s] ||= @current_page
      self.page_number += 1

      if self.page_number <= (@page_links.length - 1)
        if pages[self.page_number.to_s].present?
          @current_page = pages[self.page_number.to_s]
        else
          @current_page = convert_json(connect(@page_links[self.page_number], :Get).body)
        end
      else
        self.page_number -= 1
        @current_page
      end
    end

    def prev_page
      self.page_number -= 1

      if self.page_number >= 0 && pages[self.page_number.to_s].present?
        @current_page = pages[self.page_number.to_s]
      else
        self.page_number += 1
        @current_page
      end
    end


    # Get a pageable list of records
    def list(url="http://0.0.0.0:3001/api/#{version}/#{self.class.to_s.demodulize.underscore}", type=:Get)
      response      = connect(url, type)
      @total_pages  = response['Total'].to_i
      @page_links   = pagination_links(response)
      @current_page = convert_json(response.body)
    end

    # Get a single record
    def record(options={})
      raise MissingAttribute, 'Missing required attribute id:' unless options.key?(:id)
      response = connect("http://0.0.0.0:3001/api/#{version}/#{self.class.to_s.demodulize.underscore}/#{options[:id]}", :Get)
      @current_record = convert_json(response.body)
    end

    private

      # Recursively convert json
      def convert_json(json)
        if json.is_a?(String)
          convert_json(JSON.load(json))
        elsif json.is_a?(Array)
          json.each_with_index do |value, index|
            json[index] = convert_json(value)
          end
        else
          json
        end
      end
  end
end