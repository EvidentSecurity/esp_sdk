FactoryGirl.define do
  factory :organization, class: 'ESP::Organization' do
    skip_create

    sequence(:id) { |n| n }
    type "organizations"
    created_at { Time.current }
    name "Test Org"
    updated_at { Time.current }
    relationships do
      { sub_organizations: {
        data: [
          {
            type: "sub_organizations",
            id: "24"
          },
          {
            type: "sub_organizations",
            id: "2"
          }
        ],
        links: {
          related: "http://localhost:3000/api/v2/sub_organizations.json?filter%5Borganization_id_eq%5D=2"
        }
      },
        teams: {
          data: [
            {
              type: "teams",
              id: "2"
            },
            {
              type: "teams",
              id: "20"
            },
            {
              type: "teams",
              id: "21"
            }
          ],
          links: {
            related: "http://localhost:3000/api/v2/teams.json?filter%5Borganization_id_eq%5D=2"
          }
        }
      }
    end
  end
end
