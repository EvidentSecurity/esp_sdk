FactoryGirl.define do
  factory :suppression, class: 'ESP::Suppression' do
    skip_create

    sequence(:id) { |n| n }
    type "suppressions"
    created_at "2015-09-11T21:12:15.183Z"
    reason "I said"
    resource ''
    suppression_type "regions"
    status "active"
    updated_at "2015-09-11T21:12:15.183Z"
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
        },
        regions: {
          data: [
            {
              id: "1",
              type: "regions"
            }
          ],
          links: {
            related: "http://test.host/api/v2/regions.json?filter%5Bsuppressions_id_eq%5D=4"
          }
        },
        external_accounts: {
          data: [
            {
              id: "1015",
              type: "external_accounts"
            }
          ],
          links: {
            related: "http://test.host/api/v2/external_accounts.json?filter%5Bsuppressions_id_eq%5D=4"
          }
        },
        signatures: {
          data: [
            {
              id: "6",
              type: "signatures"
            }
          ],
          links: {
            related: "http://test.host/api/v2/signatures.json?filter%5Bid_in%5D%5B%5D=6"
          }
        },
        custom_signatures: {
          data: [
            {
              id: "6",
              type: "custom_signatures"
            }
          ],
          links: {
            related: "http://test.host/api/v2/custom_signatures.json?filter%5Bid_in%5D%5B%5D=6"
          }
        } }
    end

    trait :with_include do
      included do
        [
          {
            id: '1',
            type: "regions",
            code: "us_east_test_1"
          },
          {
            id: '1015',
            type: "external_accounts",
            account: "762160981991",
            arn: "arn:aws:iam::762160981991:role/Evident-Service-Role-Kevin",
            created_at: "2015-09-11T21:12:15.183Z",
            external_id: "913310e7-6a9c-49f7-bd69-120721ec1122",
            name: "Dev",
            updated_at: "2015-09-11T21:12:15.183Z",
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
          },
          {
            id: '6',
            type: "signatures",
            created_at: "2015-09-11T21:12:15.183Z",
            description: "Some description for some test",
            identifier: "1 Unique ID",
            name: "1_test_signature",
            resolution: "Turn on some setting",
            risk_level: "High",
            updated_at: nil,
            relationships: {
              service: {
                data: {
                  type: "services",
                  id: "1"
                },
                links: {
                  related: "http://test.host/api/v2/services/1.json"
                }
              }
            }
          },
          {
            id: '6',
            type: "custom_signatures",
            created_at: "2015-09-11T21:12:15.183Z",
            active: true,
            description: "Test description",
            identifier: "AWS::Test::001",
            name: "Test",
            resolution: "Test resolution",
            risk_level: "Medium",
            signature: "Some javascript",
            language: "javascript",
            updated_at: nil,
            relationships: {
              organization: {
                data: {
                  type: "organizations",
                  id: "1003"
                },
                links: {
                  related: "http://test.host/api/v2/organizations/1003.json"
                }
              }
            }
          }
        ]
      end
    end
  end
end
