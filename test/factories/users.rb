FactoryGirl.define do
  factory :user, class: 'ESP::User' do
    skip_create

    sequence(:id) { |n| n }
    created_at { Time.current }
    email "customer@email.com"
    time_zone "UTC"
    updated_at { Time.current }
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
          related: "http://localhost:3000/api/v2/organizations/2.json_api"
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
        }
      }
    end
  end
end
