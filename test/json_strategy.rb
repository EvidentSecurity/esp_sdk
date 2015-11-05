class JsonStrategy
  def initialize
    @strategy = FactoryGirl.strategy_by_name(:attributes_for).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    convert_to_json_api_compliant_hash(@strategy.result(evaluation)).to_json
  end

  private

  def convert_to_json_api_compliant_hash(attributes)
    return attributes if attributes[:errors].present?
    {}.tap do |h|
      h['included'] = attributes.delete(:included)
      h['data'] = {}
      h['data']['id'] = attributes.delete(:id)
      h['data']['type'] = attributes.delete(:type)
      h['data']['relationships'] = attributes.delete(:relationships) if attributes[:relationships]
      h['data']['attributes'] = attributes
    end
  end
end
