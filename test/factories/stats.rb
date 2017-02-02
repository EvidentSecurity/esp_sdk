FactoryGirl.define do
  factory :stat, class: 'ESP::Stat' do
    skip_create

    sequence(:id) { |n| n }
    type "stats"
    total 47
    total_suppressed 38
    new_1h_high_pass 3
    new_1d_high_pass 4
    new_1w_high_pass 2
    old_high_pass 2
    new_1h_high_fail 3
    new_1d_high_fail 0
    new_1w_high_fail 0
    old_high_fail 1
    new_1h_high_warn 3
    new_1d_high_warn 0
    new_1w_high_warn 1
    old_high_warn 0
    new_1h_high_error 4
    new_1d_high_error 4
    new_1w_high_error 4
    old_high_error 2
    new_1h_medium_pass 4
    new_1d_medium_pass 0
    new_1w_medium_pass 1
    old_medium_pass 2
    new_1h_medium_fail 2
    new_1d_medium_fail 0
    new_1w_medium_fail 3
    old_medium_fail 2
    new_1h_medium_warn 0
    new_1d_medium_warn 2
    new_1w_medium_warn 1
    old_medium_warn 1
    new_1h_medium_error 2
    new_1d_medium_error 2
    new_1w_medium_error 3
    old_medium_error 1
    new_1h_low_pass 4
    new_1d_low_pass 0
    new_1w_low_pass 0
    old_low_pass 4
    new_1h_low_fail 0
    new_1d_low_fail 4
    new_1w_low_fail 2
    old_low_fail 2
    new_1h_low_warn 2
    new_1d_low_warn 2
    new_1w_low_warn 2
    old_low_warn 0
    new_1h_low_error 1
    new_1d_low_error 1
    new_1w_low_error 0
    old_low_error 1
    suppressed_high_pass 3
    suppressed_high_fail 1
    suppressed_high_warn 4
    suppressed_high_error 3
    suppressed_medium_pass 2
    suppressed_medium_fail 0
    suppressed_medium_warn 3
    suppressed_medium_error 4
    suppressed_low_pass 3
    suppressed_low_fail 3
    suppressed_low_warn 2
    suppressed_low_error 3
    new_1h_high_info 0
    new_1d_high_info 4
    new_1w_high_info 2
    old_high_info 1
    new_1h_medium_info 1
    new_1d_medium_info 2
    new_1w_medium_info 1
    old_medium_info 3
    new_1h_low_info 1
    new_1d_low_info 2
    new_1w_low_info 3
    old_low_info 0
    suppressed_high_info 4
    suppressed_medium_info 1
    suppressed_low_info 2
    relationships do
      { report: {
        data: {
          id: "3",
          type: "reports"
        },
        links: {
          related: "http://test.host/api/v2/reports/3.json"
        }
      },
        regions: {
          data: [
            {
              id: "3",
              type: "stat_regions"
            }
          ]
        },
        services: {
          data: [
            {
              id: "3",
              type: "stat_services"
            }
          ]
        },
        signatures: {
          data: [
            {
              id: "3",
              type: "stat_signatures"
            }
          ]
        },
        custom_signatures: {
          data: [
            {
              id: "3",
              type: "stat_custom_signatures"
            }
          ]
        } }
    end
  end
end
