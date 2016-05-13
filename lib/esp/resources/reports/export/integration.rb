module ESP
  class Report
    module Export
      class Integration < ESP::Resource
        self.prefix += "reports/export/"
        # Not Implemented. You cannot search for Reports::Export::Integration.
        def self.where(*)
          fail ESP::NotImplementedError
        end

        # Not Implemented. You cannot search for Reports::Export::Integration.
        def self.find(*)
          fail ESP::NotImplementedError
        end

        # Not Implemented. You cannot update a Reports::Export::Integration.
        def update
          fail ESP::NotImplementedError
        end

        # Not Implemented. You cannot destroy a Reports::Export::Integration.
        def destroy
          fail ESP::NotImplementedError
        end

        # :singleton-method: create
        # Enqueue reports to be exported to the given integration
        # Returns a Report::Export::Integration object if successful
        # ==== Attribute
        #
        # See {API documentation}[http://api-docs.evident.io?ruby#report-export] for valid arguments
        #
        # If not successful, returns a Report::Export::Integration object with the errors object populated.

        protected

        # A success message gets returned, so just return the response instead of parsing for attributes
        def load_attributes_from_response(response)
          response
        end
      end
    end
  end
end
