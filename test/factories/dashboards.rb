FactoryGirl.define do
  factory :dashboard, class: 'ESP::Dashboard' do
    skip_create

    type "reports"
    team_name "Operations 1"
    sub_organization_name "IT Department 1"
    organization_name "Test Organization 1"
    created_at { Time.current }
    updated_at { Time.current }
    relationships do
      { stat: {
        data: {
          type: "stats",
          id: "1"
        },
        links: {
          related: "http://test.host/api/v2/reports/1/stats.json"
        }
      }
      }
    end
    included do
      [
        {
          id: "1",
          type: "stats",
          attributes: {
            total: 59,
            stat_signatures: [
              {
                signature: {
                  id: 1,
                  name: "1_test_signature",
                  risk_level: "High",
                  service: {
                    code: "S1",
                    id: 1,
                    name: "SSS"
                  }
                },
                total_pass: 2,
                total_fail: 6,
                total_warn: 8,
                total_error: 1,
                total_new_1h: 7,
                total_new_1d: 14
              }
            ],
            stat_custom_signatures: [
              {
                custom_signature: {
                  id: 1,
                  name: "Test",
                  risk_level: "Medium"
                },
                total_pass: 8,
                total_fail: 2,
                total_warn: 4,
                total_error: 6,
                total_new_1h: 8,
                total_new_1d: 12
              }
            ],
            stat_regions: [
              {
                region: {
                  id: 1,
                  code: "us_east_test_1"
                },
                total_pass: 16,
                total_fail: 18,
                total_warn: 12,
                total_error: 11,
                total_high: 16,
                total_medium: 18,
                total_low: 20,
                total_new_1h_high: 4,
                total_new_1h_medium: 5,
                total_new_1h_low: 9,
                total_new_1d_high: 8,
                total_new_1d_medium: 8,
                total_new_1d_low: 13
              }
            ]
          }
        }
      ]
    end
  end
end
