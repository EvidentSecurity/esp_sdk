module ESP
  class CustomSignature
    class Result < ESP::Resource
      autoload :Alert, File.expand_path(File.dirname(__FILE__) + '/result/alert')

      self.prefix += "custom_signature_"

      belongs_to :definition, class_name: 'ESP::CustomSignature::Definition', foreign_key: :definition_id
      belongs_to :region, class_name: 'ESP::Region'
      belongs_to :external_account, class_name: 'ESP::ExternalAccount'

      def alerts
        return attributes['alerts'] if attributes['alerts'].present?
        CustomSignature::Result::Alert.for_result(id)
      end

      # Not Implemented. You cannot update a CustomSignature::Result.
      def update
        fail ESP::NotImplementedError
      end

      # Not Implemented. You cannot destroy a CustomSignature::Result.
      def destroy
        fail ESP::NotImplementedError
      end

      # :singleton-method: where
      # Return a paginated CustomSignature::Result list filtered by search parameters
      #
      # ==== Parameters
      #
      # +clauses+ | Hash of attributes with appended predicates to search, sort and include.
      #
      # ===== Valid Clauses
      #
      # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-result-attributes] for valid arguments
      #
      # :call-seq:
      #  where(clauses = {})

      ##
      # :singleton-method: find
      # Find a CustomSignature::Result by id
      #
      # ==== Parameter
      #
      # +id+ | Required | The ID of the custom signature result to retrieve
      #
      # +options+ | Optional | A hash of options
      #
      # ===== Valid Options
      #
      # +include+ | The list of associated objects to return on the initial request.
      #
      # ===== Valid Includable Associations
      #
      # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-result-attributes] for valid arguments
      #
      # :call-seq:
      #  find(id, options = {})

      # :singleton-method: all
      # Return a paginated CustomSignature::Result list

      # :singleton-method: create
      # Create a CustomSignature::Result
      # :call-seq:
      #   create(attributes={})
      #
      # ==== Parameter
      #
      # +attributes+ | Required | A hash of custom signature result attributes
      #
      # ===== Valid Attributes
      #
      # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-result-create] for valid arguments
      #
      # ==== Example
      #
      #  signature = "# Demo Ruby Signature\r\nconfigure do |c|\r\n  # Set regions to run in. Remove this line to run in all regions.\r\n  c.valid_regions     = [:us_east_1]\r\n  # Override region to display as global. Useful when checking resources\r\n  # like IAM that do not have a specific region.\r\n  c.display_as        = :global\r\n  # deep_inspection works with set_data to automically collect\r\n  # data fields for each alert. Not required.\r\n  c.deep_inspection   = [:users]\r\nend\r\n\r\n# Required perform method\r\ndef perform(aws)\r\n  list_users = aws.iam.list_users\r\n  count = list_users[:users].count\r\n\r\n  # Set data for deep_inspection to use\r\n  set_data(list_users)\r\n\r\n  if count == 0\r\n    fail(user_count: count, condition: 'count == 0')\r\n  else\r\n    pass(user_count: count, condition: 'count >= 1')\r\n  end\r\nend\r\n"
      #  result = ESP::CustomSignature::Result.create(signature: signature, language: "ruby", region_id: 1, external_account_id: 1)

      # :method: save
      # Create or update a CustomSignature::Result
      #
      # ===== Valid Attributes
      #
      # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-result-create] for valid arguments
      #
      # ==== Example
      #
      #  signature = "# Demo Ruby Signature\r\nconfigure do |c|\r\n  # Set regions to run in. Remove this line to run in all regions.\r\n  c.valid_regions     = [:us_east_1]\r\n  # Override region to display as global. Useful when checking resources\r\n  # like IAM that do not have a specific region.\r\n  c.display_as        = :global\r\n  # deep_inspection works with set_data to automically collect\r\n  # data fields for each alert. Not required.\r\n  c.deep_inspection   = [:users]\r\nend\r\n\r\n# Required perform method\r\ndef perform(aws)\r\n  list_users = aws.iam.list_users\r\n  count = list_users[:users].count\r\n\r\n  # Set data for deep_inspection to use\r\n  set_data(list_users)\r\n\r\n  if count == 0\r\n    fail(user_count: count, condition: 'count == 0')\r\n  else\r\n    pass(user_count: count, condition: 'count >= 1')\r\n  end\r\nend\r\n"
      #  result = ESP::CustomSignature::Result.new(signature: signature, language: "ruby", region_id: 1, external_account_id: 1)
      #  result.save
    end
  end
end
