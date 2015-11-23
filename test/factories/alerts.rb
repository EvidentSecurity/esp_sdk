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
    relationships do
      {
        external_account: {
          data: {
            type: "external_accounts",
            id: "1015"
          },
          links: {
            related: "http://test.host/api/v2/external_accounts/1015.json_api"
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
            related: "http://test.host/api/v2/signatures/1013.json_api"
          }
        },
        custom_signature: {
          data: nil
        },
        suppression: {
          data: {
            id: "1",
            type: "suppressions"
          },
          links: {
            related: "http://test.host/api/v2/suppressions/1.json_api"
          }
        },
        cloud_trail_events: {
          data: [
            {
              type: "cloud_trail_events",
              id: "1"
            }
          ],
          links: {
            related: "http://test.host/api/v2/alerts/1017/cloud_trail_events.json_api"
          }
        },
        tags: {
          data: [
            {
              id: "1",
              type: "tags"
            },
            {
              id: "2",
              type: "tags"
            }
          ]
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
                related: "http://test.host/api/v2/organizations/5.json_api"
              }
            },
            sub_organization: {
              data: {
                type: "sub_organizations",
                id: "5"
              },
              links: {
                related: "http://test.host/api/v2/sub_organizations/5.json_api"
              }
            },
            team: {
              data: {
                type: "teams",
                id: "5"
              },
              links: {
                related: "http://test.host/api/v2/teams/5.json_api"
              }
            },
            user_attribution_role: {
              data: nil
            }
          }
        },
        {
          id: '5',
          type: "teams",
          name: "Default Team",
          created_at: "2015-09-11T21:12:15.183Z",
          updated_at: "2015-09-11T21:12:15.183Z",
          relationships: {
            sub_organization: {
              data: {
                type: "sub_organizations",
                id: "5"
              },
              links: {
                related: "http://localhost:3000/api/v2/sub_organizations/2.json_api"
              }
            },
            organization: {
              data: {
                type: "organizations",
                id: "5"
              },
              links: {
                related: "http://localhost:3000/api/v2/organizations/2.json_api"
              }
            }
          }
        },
        {
          id: '5',
          type: "organizations",
          created_at: "2015-09-11T21:12:15.183Z",
          name: "Test Org",
          updated_at: "2015-09-11T21:12:15.183Z",
          relationships: {
            sub_organizations: {
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
                related: "http://test.host/api/v2/services/3.json_api"
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
        },
        {
          id: "1",
          type: "suppressions",
          attributes: {
            created_at: "2015-10-16T18:34:19.464Z",
            reason: "I dont like this",
            status: "setup",
            updated_at: "2015-10-16T18:34:19.464Z",
            configuration: {
              suppression_type: "regions",
              resource: nil,
              regions: [
                {
                  id: "4",
                  type: "regions",
                  attributes: {
                    code: "us_east_test_4"
                  }
                }
              ],
              external_accounts: []
            }
          },
          relationships: {
            organization: {
              data: {
                id: "4",
                type: "organizations"
              },
              links: {
                related: "http://test.host/api/v2/organizations/4.json_api"
              }
            },
            created_by: {
              data: {
                id: "1",
                type: "users"
              },
              links: {
                related: "http://test.host/api/v2/users/1.json_api"
              }
            }
          }
        },
        {
          id: "1",
          type: "tags",
          attributes: {
            key: "Name",
            value: "abc123",
            created_at: "2015-10-16T18:34:19.569Z",
            updated_at: "2015-10-16T18:34:19.569Z"
          }
        },
        {
          id: "2",
          type: "tags",
          attributes: {
            key: "Name",
            value: "abc123",
            created_at: "2015-10-16T18:34:19.571Z",
            updated_at: "2015-10-16T18:34:19.571Z"
          }
        }
      ]
    end
  end
end
