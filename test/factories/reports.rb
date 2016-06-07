FactoryGirl.define do
  factory :report, class: 'ESP::Report' do
    skip_create

    sequence(:id) { |n| n }
    type "reports"
    created_at { Time.current }
    status "complete"
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
        },
        alerts: {
          links: {
            related: "http://localhost:3000/api/v2/reports/55/alerts.json"
          }
        }
      }
    end
  end
end
