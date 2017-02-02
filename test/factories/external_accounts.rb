FactoryGirl.define do
  factory :external_account, class: 'ESP::ExternalAccount' do
    skip_create

    sequence(:id) { |n| n }
    type "external_accounts"
    account "762160981991"
    arn "arn:aws:iam::762160981991:role/Evident-Service-Role-Kevin"
    created_at { Time.current }
    external_id "913310e7-6a9c-49f7-bd69-120721ec1122"
    name "Dev"
    updated_at { Time.current }
    relationships do
      { organization: {
        data: {
          type: "organizations",
          id: "1"
        },
        links: {
          related: "http://localhost:3000/api/v2/organizations/1.json"
        }
      },
        sub_organization: {
          data: {
            type: "sub_organizations",
            id: "1"
          },
          links: {
            related: "http://localhost:3000/api/v2/sub_organizations/1.json"
          }
        },
        team: {
          data: {
            type: "teams",
            id: "1"
          },
          links: {
            related: "http://localhost:3000/api/v2/teams/1.json"
          }
        } }
    end
  end
end
