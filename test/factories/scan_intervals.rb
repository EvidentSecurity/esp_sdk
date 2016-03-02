FactoryGirl.define do
  factory :scan_interval, class: 'ESP::ScanInterval' do
    skip_create

    sequence(:id) { |n| n }
    type "scan_intervals"
    interval 15
    created_at { Time.current }
    updated_at { Time.current }
    relationships do
      { external_account: {
        data: {
          type: "external_accounts",
          id: "1"
        },
        links: {
          related: "http://localhost:3000/api/v2/external_accounts/1.json"
        }
      },
        service: {
          data: {
            type: "services",
            id: "1"
          },
          links: {
            related: "http://localhost:3000/api/v2/services/1.json"
          }
        }
      }
    end
  end
end
