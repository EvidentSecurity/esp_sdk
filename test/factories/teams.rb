FactoryGirl.define do
  factory :team, class: 'ESP::Team' do
    skip_create

    sequence(:id) { |n| n }
    type "teams"
    name "Default Team"
    created_at { Time.current }
    updated_at { Time.current }
    relationships do
      { sub_organization: {
        data: {
          type: "sub_organizations",
          id: "2"
        },
        links: {
          related: "http://localhost:3000/api/v2/sub_organizations/2.json"
        }
      },
        organization: {
          data: {
            type: "organizations",
            id: "2"
          },
          links: {
            related: "http://localhost:3000/api/v2/organizations/2.json"
          }
        }
      }
    end
  end
end
