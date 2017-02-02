FactoryGirl.define do
  factory :user, class: 'ESP::User' do
    skip_create

    sequence(:id) { |n| n }
    created_at "2015-09-11T21:12:15.183Z"
    email "customer@email.com"
    time_zone "UTC"
    updated_at "2015-09-11T21:12:15.183Z"
    first_name "Custom"
    last_name "McGaa"
    phone "8135551234"
    role "customer"
    mfa_enabled false
    disable_daily_emails false
    locked false
    locked_at nil

    relationships do
      { organization: {
        data: {
          type: "organizations",
          id: "2"
        },
        links: {
          related: "http://localhost:3000/api/v2/organizations/2.json"
        }
      },
        sub_organizations: {
          data: [
            {
              type: "sub_organizations",
              id: "2"
            }
          ],
          links: {
            related: "http://localhost:3000/api/v2/sub_organizations.json?filter%5Bq%5D%5Bid_in%5D%5B%5D=1"
          }
        },
        teams: {
          data: [
            {
              type: "teams",
              id: "2"
            }
          ],
          links: {
            related: "http://localhost:3000/api/v2/teams.json?filter%5Bq%5D%5Bid_in%5D%5B%5D=1"
          }
        } }
    end

    trait :with_include do
      included do
        [
          {
            id: '2',
            type: "teams",
            name: "Default Team",
            created_at: "2015-09-11T21:12:15.183Z",
            updated_at: "2015-09-11T21:12:15.183Z",
            relationships: {
              sub_organization: {
                data: {
                  type: "sub_organizations",
                  id: "2"
                },
                links: {
                  related: "http://localhost:3000/api/v2/sub_organizations/2.json"
                }
              },
              organization: {
                data: {
                  type: "organizations",
                  id: "2"
                },
                links: {
                  related: "http://localhost:3000/api/v2/organizations/2.json"
                }
              }
            }
          },
          {
            id: '2',
            type: "sub_organizations",
            name: "Default Sub Organization",
            created_at: "2015-09-11T21:12:15.183Z",
            updated_at: "2015-09-11T21:12:15.183Z",
            relationships: {
              organization: {
                data: {
                  type: "organizations",
                  id: "2"
                },
                links: {
                  related: "http://localhost:3000/api/v2/organizations/2.json"
                }
              },
              teams: {
                data: [
                  {
                    type: "teams",
                    id: "2"
                  }
                ],
                links: {
                  related: "http://localhost:3000/api/v2/teams.json?filter%5Bsub_organization_id_eq%5D=2"
                }
              }
            }
          }
        ]
      end
    end
  end
end
