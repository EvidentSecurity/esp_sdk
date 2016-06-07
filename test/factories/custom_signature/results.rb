FactoryGirl.define do
  factory :result, class: 'ESP::CustomSignature::Result' do
    skip_create

    sequence(:id) { |n| n }
    code 'abc'
    created_at { Time.current }
    language 'javascript'
    status "complete"
    updated_at { Time.current }

    relationships do
      {
        definition: {
          data: {
            type: "definitions",
            id: "1"
          },
          links: {
            related: "http://localhost:3000/api/v2/custom_signature_definitions/1.json"
          }
        },
        region: {
          data: {
            type: "regions",
            id: "1"
          },
          links: {
            related: "http://localhost:3000/api/v2/regions/1.json"
          }
        },
        external_account: {
          data: {
            type: "external_accounts",
            id: "1"
          },
          links: {
            related: "http://localhost:3000/api/v2/external_accounts/1.json"
          }
        },
        alerts: {
          links: {
            related: "http://localhost:3000/api/v2/custom_signature_results/#{id}/alerts.json"
          }
        }
      }
    end
  end
end
