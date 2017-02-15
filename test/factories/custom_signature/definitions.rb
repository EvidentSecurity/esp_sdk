FactoryGirl.define do
  factory :definition, class: 'ESP::CustomSignature::Definition' do
    skip_create

    sequence(:id) { |n| n }
    code 'abc'
    created_at { Time.current }
    language 'javascript'
    status "active"
    updated_at { Time.current }

    relationships do
      { custom_signature: {
        data: {
          type: "custom_signatures",
          id: "1"
        },
        links: {
          related: "http://localhost:3000/api/v2/custom_signatures/1.json"
        }
      },
        results: {
          links: {
            related: "http://localhost:3000/api/v2/custom_signature_results.json?filter%5Bdefinition_id_eq%5D=#{id}"
          }
        } }
    end
  end
end
