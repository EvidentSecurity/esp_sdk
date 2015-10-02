FactoryGirl.define do
  factory :alert, class: 'ESP::Alert' do
    skip_create

    sequence(:id) { |n| n }
    type "alerts"
    created_at { Time.current }
    status "fail"
    resource "resource-3"
    updated_at nil
    metadata { { abc: 123 } }
    started_at { Time.current }
    ended_at nil
    suppression do
      {
        id: nil,
        reason: nil,
        user_email: nil
      }
    end
    tags do
      [
        {
          key: "Name",
          value: "abc123"
        },
        {
          key: "Name",
          value: "abc123"
        }
      ]
    end
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
        signature: {
          data: {
            type: "signatures",
            id: "1013"
          },
          links: {
            related: "http://test.host/api/v2/signatures/1013.json"
          }
        },
        custom_signature: {
          data: nil
        },
        cloud_trail_events: {
          data: [
            {
              type: "cloud_trail_events",
              id: "1"
            }
          ],
          links: {
            related: "http://test.host/api/v2/alerts/1017/cloud_trail_events.json"
          }
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
        },
        {
          id: "1013",
          type: "signatures",
          attributes: {
            created_at: "2015-09-11T21:12:15.192Z",
            description: "\"Some description for some test\"",
            identifier: "3 Unique ID",
            name: "3_test_signature",
            resolution: "\"Turn on some setting\"",
            risk_level: "High",
            updated_at: nil
          },
          relationships: {
            service: {
              data: {
                type: "services",
                id: "3"
              },
              links: {
                related: "http://test.host/api/v2/services/3.json"
              }
            }
          }
        },
        {
          id: "1",
          type: "cloud_trail_events",
          attributes: {
            event_id: "1",
            event_name: "1",
            event_time: "2015-09-11T21:12:14.661Z",
            username: "johndoe",
            ip_address: "123.0.0.123",
            user_agent: "Chrome"
          }
        }
      ]
    end
  end
end
