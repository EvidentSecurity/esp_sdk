FactoryGirl.define do
  factory :custom_signature, class: 'ESP::CustomSignature' do
    skip_create

    sequence(:id) { |n| n }
    type "custom_signatures"
    created_at { Time.current }
    active true
    description "Test description"
    identifier "AWS::Test::001"
    name "Test"
    resolution "Test resolution"
    risk_level "Medium"
    updated_at nil
    relationships do
      {
        organization: {
          links: {
            related: "http://test.host/api/v2/organizations/1003.json"
          }
        },
        teams: {
          links: {
            related: "http://test.host/api/v2/teams?filter%5Bcustom_signatures_id_eq%5D=#{id}"
          }
        }
      }
    end
  end
end
