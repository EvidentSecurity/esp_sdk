FactoryGirl.define do
  factory :suppression_region, class: 'ESP::Suppression::Region' do
    skip_create

    sequence(:id) { |n| n }
    type "suppressions"
    created_at { Time.current }
    reason "because"
    status "active"
    updated_at { Time.current }
    configuration do
      { suppression_type: "regions",
        resource: nil,
        regions: [
          {
            id: "1",
            type: "regions",
            attributes: {
              code: "ap_northeast_1"
            }
          }
        ],
        external_accounts: [
          {
            id: "1",
            type: "external_accounts",
            attributes: {
              account: "762160981991",
              arn: "arn:aws:iam::762160981991:role/Evident-Service-Role-Kevin",
              created_at: "2015-09-23T14:43:47.000Z",
              external_id: "913310e7-6a9c-49f7-bd69-120721ec1122",
              name: "Dev",
              updated_at: "2015-09-23T14:43:47.000Z"
            },
            relationships: {
              organization: {
                data: {
                  id: "1",
                  type: "organizations"
                },
                links: {
                  related: "http://localhost:3000/api/v2/organizations/1.json"
                }
              },
              sub_organization: {
                data: {
                  id: "1",
                  type: "sub_organizations"
                },
                links: {
                  related: "http://localhost:3000/api/v2/sub_organizations/1.json"
                }
              },
              team: {
                data: {
                  id: "1",
                  type: "teams"
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
          id: "1",
          type: "organizations"
        },
        links: {
          related: "http://localhost:3000/api/v2/organizations/1.json"
        }
      },
        created_by: {
          data: {
            id: "1",
            type: "users"
          },
          links: {
            related: "http://localhost:3000/api/v2/users/1.json"
          }
        }
      }
    end
  end
end
