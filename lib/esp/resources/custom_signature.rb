module ESP
  class CustomSignature < ESP::Resource
    ##
    # The organization this custom signature belongs to.
    belongs_to :organization, class_name: 'ESP::Organization'

    ##
    # The collection of teams that belong to the custom_signature.
    def teams
      return attributes['teams'] if attributes['teams'].present?
      Team.where(custom_signatures_id_eq: id)
    end

    # Run a custom signature that has not been saved.  Useful for debugging a custom signature.
    # Returns a collection of alerts.
    # Throws an error if not successful.
    #
    # ==== Parameters
    #
    # +arguments+ | Required | A hash of run arguments
    #
    # ===== Valid Arguments
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-run-new] for valid arguments
    #
    # ==== Example
    #   signature = "# Demo Ruby Signature\r\nconfigure do |c|\r\n  # Set regions to run in. Remove this line to run in all regions.\r\n  c.valid_regions     = [:us_east_1]\r\n  # Override region to display as global. Useful when checking resources\r\n  # like IAM that do not have a specific region.\r\n  c.display_as        = :global\r\n  # deep_inspection works with set_data to automically collect\r\n  # data fields for each alert. Not required.\r\n  c.deep_inspection   = [:users]\r\nend\r\n\r\n# Required perform method\r\ndef perform(aws)\r\n  list_users = aws.iam.list_users\r\n  count = list_users[:users].count\r\n\r\n  # Set data for deep_inspection to use\r\n  set_data(list_users)\r\n\r\n  if count == 0\r\n    fail(user_count: count, condition: 'count == 0')\r\n  else\r\n    pass(user_count: count, condition: 'count >= 1')\r\n  end\r\nend\r\n"
    #   alerts = ESP::CustomSignature.run!(external_account_id: 3, regions: ['us_east_1'], language: 'ruby', signature: signature)
    def self.run!(arguments = {})
      result = run(arguments)
      return result if result.is_a?(ActiveResource::Collection)
      result.message = result.errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(result)) # rubocop:disable Style/RaiseArgs
    end

    # Run a custom signature that has not been saved.  Useful for debugging a custom signature.
    # Returns a collection of alerts.
    # If not successful, returns a CustomSignature object with the errors object populated.
    #
    # ==== Parameters
    #
    # +arguments+ | Required | A hash of run arguments
    #
    # ===== Valid Arguments
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-run-new] for valid arguments
    #
    # ==== Example
    #   signature = "# Demo Ruby Signature\r\nconfigure do |c|\r\n  # Set regions to run in. Remove this line to run in all regions.\r\n  c.valid_regions     = [:us_east_1]\r\n  # Override region to display as global. Useful when checking resources\r\n  # like IAM that do not have a specific region.\r\n  c.display_as        = :global\r\n  # deep_inspection works with set_data to automically collect\r\n  # data fields for each alert. Not required.\r\n  c.deep_inspection   = [:users]\r\nend\r\n\r\n# Required perform method\r\ndef perform(aws)\r\n  list_users = aws.iam.list_users\r\n  count = list_users[:users].count\r\n\r\n  # Set data for deep_inspection to use\r\n  set_data(list_users)\r\n\r\n  if count == 0\r\n    fail(user_count: count, condition: 'count == 0')\r\n  else\r\n    pass(user_count: count, condition: 'count >= 1')\r\n  end\r\nend\r\n"
    #   alerts = ESP::CustomSignature.run(external_account_id: 3, regions: ['us_east_1'], language: 'ruby', signature: signature)
    def self.run(arguments = {})
      arguments = arguments.with_indifferent_access
      arguments[:regions] = Array(arguments[:regions])
      new(arguments).run
    end

    # Run this custom signature instance.
    # Returns a collection of alerts.
    # Throws an error if not successful.
    #
    # ==== Parameters
    #
    # +arguments+ | Required | A hash of run arguments
    #
    # ===== Valid Arguments
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-run-existing] for valid arguments
    #
    # ==== Example
    #   custom_signature = ESP::CustomSignature.find(365)
    #   alerts = custom_signature.run!(external_account_id: 3, regions: ['us_east_1'])
    def run!(arguments = {})
      result = run(arguments)
      return result if result.is_a?(ActiveResource::Collection)
      self.message = errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(self)) # rubocop:disable Style/RaiseArgs
    end

    # Run this custom signature instance.
    # Returns a collection of alerts.
    # If not successful, returns a CustomSignature object with the errors object populated.
    #
    # ==== Parameters
    #
    # +arguments+ | Required | A hash of run arguments
    #
    # ===== Valid Arguments
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-run-existing] for valid arguments
    #
    # ==== Example
    #   custom_signature = ESP::CustomSignature.find(365)
    #   alerts = custom_signature.run(external_account_id: 3, regions: ['us_east_1'])
    def run(arguments = {})
      arguments = arguments.with_indifferent_access

      attributes['external_account_id'] ||= arguments[:external_account_id]
      attributes['regions'] ||= Array(arguments[:regions])

      response = connection.post endpoint, to_json
      ESP::Alert.send(:instantiate_collection, self.class.format.decode(response.body))
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid, ActiveResource::ResourceNotFound => error
      load_remote_errors(error, true)
      self.code = error.response.code
      self
    end

    # Create a suppression for this custom signature.
    #
    # ==== Parameter
    #
    # +arguments+ | Required | A hash of signature suppression attributes
    #
    # ===== Valid Arguments
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#suppression-create] for valid arguments
    #
    # ==== Example
    #   suppress(regions: ['us_east_1'], external_account_ids: [5], reason: 'My very good reason for creating this suppression')
    def suppress(arguments = {})
      arguments = arguments.with_indifferent_access
      ESP::Suppression::Signature.create(custom_signature_ids: [id], regions: Array(arguments[:regions]), external_account_ids: Array(arguments[:external_account_ids]), reason: arguments[:reason])
    end

    # :singleton-method: where
    # Return a paginated CustomSignature list filtered by search parameters
    #
    # ==== Parameters
    #
    # +clauses+ | Hash of attributes with appended predicates to search, sort and include.
    #
    # ===== Valid Clauses
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-attributes] for valid arguments
    #
    # :call-seq:
    #  where(clauses = {})

    ##
    # :singleton-method: find
    # Find a CustomSignature by id
    #
    # ==== Parameter
    #
    # +id+ | Required | The ID of the custom signature to retrieve
    #
    # +options+ | Optional | A hash of options
    #
    # ===== Valid Options
    #
    # +include+ | The list of associated objects to return on the initial request.
    #
    # ===== Valid Includable Associations
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-attributes] for valid arguments
    #
    # :call-seq:
    #  find(id, options = {})

    # :singleton-method: all
    # Return a paginated CustomSignature list

    # :singleton-method: create
    # Create a CustomSignature
    # :call-seq:
    #   create(attributes={})
    #
    # ==== Parameter
    #
    # +attributes+ | Required | A hash of custom signature attributes
    #
    # ===== Valid Attributes
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-create] for valid arguments
    #
    # ==== Example
    #
    #  signature = "# Demo Ruby Signature\r\nconfigure do |c|\r\n  # Set regions to run in. Remove this line to run in all regions.\r\n  c.valid_regions     = [:us_east_1]\r\n  # Override region to display as global. Useful when checking resources\r\n  # like IAM that do not have a specific region.\r\n  c.display_as        = :global\r\n  # deep_inspection works with set_data to automically collect\r\n  # data fields for each alert. Not required.\r\n  c.deep_inspection   = [:users]\r\nend\r\n\r\n# Required perform method\r\ndef perform(aws)\r\n  list_users = aws.iam.list_users\r\n  count = list_users[:users].count\r\n\r\n  # Set data for deep_inspection to use\r\n  set_data(list_users)\r\n\r\n  if count == 0\r\n    fail(user_count: count, condition: 'count == 0')\r\n  else\r\n    pass(user_count: count, condition: 'count >= 1')\r\n  end\r\nend\r\n"
    #  custom_signature = ESP::CustomSignature.create(signature: signature, description: "A test custom signature.", identifier: "AWS::IAM::001", language: "ruby", name: "Test Signature", risk_level: "Medium")

    # :method: save
    # Create or update a CustomSignature
    #
    # ===== Valid Attributes
    #
    # See {API documentation}[http://api-docs.evident.io?ruby#custom-signature-create] for valid arguments
    #
    # ==== Example
    #
    #  signature = "# Demo Ruby Signature\r\nconfigure do |c|\r\n  # Set regions to run in. Remove this line to run in all regions.\r\n  c.valid_regions     = [:us_east_1]\r\n  # Override region to display as global. Useful when checking resources\r\n  # like IAM that do not have a specific region.\r\n  c.display_as        = :global\r\n  # deep_inspection works with set_data to automically collect\r\n  # data fields for each alert. Not required.\r\n  c.deep_inspection   = [:users]\r\nend\r\n\r\n# Required perform method\r\ndef perform(aws)\r\n  list_users = aws.iam.list_users\r\n  count = list_users[:users].count\r\n\r\n  # Set data for deep_inspection to use\r\n  set_data(list_users)\r\n\r\n  if count == 0\r\n    fail(user_count: count, condition: 'count == 0')\r\n  else\r\n    pass(user_count: count, condition: 'count >= 1')\r\n  end\r\nend\r\n"
    #  custom_signature = ESP::CustomSignature.new(signature: signature, description: "A test custom signature.", identifier: "AWS::IAM::001", language: "ruby", name: "Test Signature", risk_level: "Medium")
    #  custom_signature.save

    # :method: destroy
    # Delete a CustomSignature

    private

    def endpoint
      if id.present?
        "#{self.class.prefix}custom_signatures/#{id}/run.json"
      else
        "#{self.class.prefix}custom_signatures/run.json"
      end
    end
  end
end
