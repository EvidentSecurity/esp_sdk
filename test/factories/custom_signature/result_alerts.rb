FactoryGirl.define do
  factory :result_alert, class: 'ESP::CustomSignature::Result::Alert' do
    skip_create

    sequence(:id) { |n| n }
    type "alerts"
    created_at { Time.current }
    status "fail"
    resource "resource-3"
    updated_at nil
    started_at { Time.current }
    ended_at nil
    metadata { { abc: '123' } }
    tags { [{ key: 'Name', value: 'i-abc123' }] }
    relationships do
      {
        external_account: {
          data: {
            type: "external_accounts",
            id: "1015"
          },
          links: {
            related: "http://test.host/api/v2/external_accounts/1015.json"
          }
        },
        region: {
          data: {
            type: "regions",
            id: "1014"
          }
        },
        custom_signature: {
          data: nil
        }
      }
    end
    included do
      [
        {
          id: "1015",
          type: "external_accounts",
          attributes: {
            account: "5",
            arn: "arn:aws:iam::5:role/test_sts_role",
            created_at: "2015-09-11T21:12:15.183Z",
            external_id: "test_sts_external_id_1",
            name: nil,
            updated_at: nil,
            user_attribution_role: nil
          },
          relationships: {
            organization: {
              data: {
                type: "organizations",
                id: "5"
              },
              links: {
                related: "http://test.host/api/v2/organizations/5.json"
              }
            },
            sub_organization: {
              data: {
                type: "sub_organizations",
                id: "5"
              },
              links: {
                related: "http://test.host/api/v2/sub_organizations/5.json"
              }
            },
            team: {
              data: {
                type: "teams",
                id: "5"
              },
              links: {
                related: "http://test.host/api/v2/teams/5.json"
              }
            },
            user_attribution_role: {
              data: nil
            }
          }
        },
        {
          id: "1014",
          type: "regions",
          attributes: {
            code: "us_east_test_3"
          }
        }
      ]
    end
  end
end
