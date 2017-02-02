FactoryGirl.define do
  factory :suppression_unique_identifier, class: 'ESP::Suppression::UniqueIdentifier' do
    skip_create

    sequence(:id) { |n| n }
    type "suppressions"
    created_at { Time.current }
    reason "because"
    status "active"
    updated_at { Time.current }
    configuration do
      { suppression_type: "unique_identifiers",
        resource: "test-cloudtrail-johnathan",
        custom_signature: nil,
        signature: {
          id: "67",
          type: "signatures",
          attributes: {
            created_at: "2015-09-23T14:37:49.000Z",
            description: "\"This signature detects the presence of \\\"Global Edit\\\" ACL permissions on S3 Bucket(s) for the All Users group. These permissions permit anyone, malicious or not, to edit the bucket and/or contents of your S3 bucket if they can guess the namespace. Since the S3 service does not protect the namespace other than with ACLs, you risk exposing critical data by leaving this open.\"",
            identifier: "AWS:SSS-004",
            name: "S3 Bucket has Global Edit ACL Permissions Enabled",
            resolution: "\"Log into your AWS console and select the S3 service. Locate the affected bucket and click on it. Select the \\\"Properties\\\" button in the upper right of the window, and expand the \\\"Permissions\\\" object.  Remove the \\\"Edit\\\" checkbox next to \\\"Everyone\\\".  More information about managing S3 access with ACLs can be found in the S3 ACL Documentation.\"",
            risk_level: "High",
            updated_at: "2015-09-23T14:37:49.000Z"
          },
          relationships: {
            service: {
              data: {
                id: "2",
                type: "services"
              },
              links: {
                related: "http://localhost:3000/api/v2/services/2.json"
              }
            }
          }
        },
        region: {
          id: "1",
          type: "regions",
          attributes: {
            code: "ap_northeast_1"
          }
        },
        external_account: {
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
        } }
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
        } }
    end
  end
end
