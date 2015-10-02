FactoryGirl.define do
  factory :contact_request, class: 'ESP::ContactRequest' do
    skip_create

    sequence(:id) { |n| n }
    type "contact_requests"
    title "test2"
    request_type "Support"
    description "description"
    created_at { Time.current }
    updated_at { Time.current }
    relationships do
      { user: {
        data: {
          type: "users",
          id: "23"
        },
        links: {
          related: "http://localhost:3000/api/v2/users/23.json"
        }
      }
      }
    end
  end
end
