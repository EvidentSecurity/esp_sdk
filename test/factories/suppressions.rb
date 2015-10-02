FactoryGirl.define do
  factory :suppression, class: 'ESP::Suppression' do
    skip_create

    sequence(:id) { |n| n }
    type "suppressions"
    created_at { Time.current }
    reason "I said"
    status "active"
    updated_at { Time.current }
    configuration do
      { suppression_type: "regions",
        resource: nil,
        regions: [
          {
            id: "7",
            type: "regions",
            attributes: {
              code: "us_east_1"
            }
          }
        ],
        external_accounts: [
          {
            id: "2",
            type: "external_accounts",
            attributes: {
              account: "762160981991",
              arn: "arn:aws:iam::762160981991:role/Evident-Service-Role-Kevin",
              created_at: Time.current,
              external_id: "913310e7-6a9c-49f7-bd69-120721ec1122",
              name: "Dev",
              updated_at: Time.current
            },
            relationships: {
              organization: {
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
              }
            }
          }
        ]
      }
    end
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
        created_by: {
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
