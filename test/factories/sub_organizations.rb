FactoryGirl.define do
  factory :sub_organization, class: 'ESP::SubOrganization' do
    skip_create

    sequence(:id) { |n| n }
    type "sub_organizations"
    name "Default Sub Organization"
    created_at { Time.current }
    updated_at { Time.current }
    relationships do
      { organization: {
        data: {
          type: "organizations",
          id: "45"
        },
        links: {
          related: "http://localhost:3000/api/v2/organizations/45.json_api"
        }
      },
        teams: {
          data: [
            {
              type: "teams",
              id: "33"
            }
          ],
          links: {
            related: "http://localhost:3000/api/v2/teams.json?filter%5Bsub_organization_id_eq%5D=34"
          }
        }
      }
    end
  end
end
