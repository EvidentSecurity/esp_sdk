module ESP
  class Report
    module Export
      class Integration < ESP::Resource
        self.prefix += "reports/export/"

        # @!method self.create(attributes = {})
        #   Enqueue reports to be exported to the given integration
        #   Returns a Report::Export::Integration object if successful
        #
        #   If not successful, returns a Report::Export::Integration object with the errors object populated.
        #
        #   @param attributes [Hash] See {API documentation}[http://api-docs.evident.io?ruby#report-export] for valid arguments
        #   @return [ESP::Report::Export::Integration]

        # Not Implemented. You cannot search for Report::Export::Integration.
        #
        # @return [void]
        def self.where(*)
          fail ESP::NotImplementedError
        end

        # Not Implemented. You cannot search for Report::Export::Integration.
        #
        # @return [void]
        def self.find(*)
          fail ESP::NotImplementedError
        end

        # Not Implemented. You cannot update a Report::Export::Integration.
        #
        # @return [void]
        def update
          fail ESP::NotImplementedError
        end

        # Not Implemented. You cannot destroy a Report::Export::Integration.
        #
        # @return [void]
        def destroy
          fail ESP::NotImplementedError
        end

        protected

        # A success message gets returned, so just return the response instead of parsing for attributes
        def load_attributes_from_response(response)
          response
        end
      end
    end
  end
end
