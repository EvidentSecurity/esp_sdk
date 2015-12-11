FactoryGirl.define do
  factory :signature, class: 'ESP::Signature' do
    skip_create

    sequence(:id) { |n| n }
    type "signatures"
    created_at { Time.current }
    description "Some description for some test"
    identifier "1 Unique ID"
    name "1_test_signature"
    resolution "Turn on some setting"
    risk_level "High"
    updated_at nil
    relationships do
      {
        service: {
          data: {
            type: "services",
            id: "1"
          },
          links: {
            related: "http://test.host/api/v2/services/1.json"
          }
        }
      }
    end
  end
end
