FactoryGirl.define do
  factory :stat_service, class: 'ESP::StatService' do
    skip_create

    sequence(:id) { |n| n }
    type "stat_services"

    new_1h_high_pass 3
    new_1d_high_pass 0
    new_1w_high_pass 4
    old_high_pass 1
    new_1h_high_fail 3
    new_1d_high_fail 3
    new_1w_high_fail 2
    old_high_fail 4
    new_1h_high_warn 1
    new_1d_high_warn 0
    new_1w_high_warn 3
    old_high_warn 4
    new_1h_high_error 1
    new_1d_high_error 0
    new_1w_high_error 4
    old_high_error 0
    new_1h_medium_pass 4
    new_1d_medium_pass 3
    new_1w_medium_pass 0
    old_medium_pass 2
    new_1h_medium_fail 4
    new_1d_medium_fail 3
    new_1w_medium_fail 3
    old_medium_fail 3
    new_1h_medium_warn 3
    new_1d_medium_warn 1
    new_1w_medium_warn 4
    old_medium_warn 3
    new_1h_medium_error 0
    new_1d_medium_error 2
    new_1w_medium_error 3
    old_medium_error 4
    new_1h_low_pass 4
    new_1d_low_pass 2
    new_1w_low_pass 3
    old_low_pass 4
    new_1h_low_fail 3
    new_1d_low_fail 4
    new_1w_low_fail 4
    old_low_fail 1
    new_1h_low_warn 0
    new_1d_low_warn 3
    new_1w_low_warn 1
    old_low_warn 0
    new_1h_low_error 4
    new_1d_low_error 1
    new_1w_low_error 3
    old_low_error 0
    suppressed_high_pass 2
    suppressed_high_fail 2
    suppressed_high_warn 2
    suppressed_high_error 3
    suppressed_medium_pass 4
    suppressed_medium_fail 2
    suppressed_medium_warn 4
    suppressed_medium_error 4
    suppressed_low_pass 0
    suppressed_low_fail 4
    suppressed_low_warn 0
    suppressed_low_error 4
    new_1h_high_info 1
    new_1d_high_info 4
    new_1w_high_info 0
    old_high_info 0
    new_1h_medium_info 0
    new_1d_medium_info 2
    new_1w_medium_info 1
    old_medium_info 2
    new_1h_low_info 0
    new_1d_low_info 2
    new_1w_low_info 1
    old_low_info 1
    suppressed_high_info 0
    suppressed_medium_info 2
    suppressed_low_info 1
    relationships do
      { service: {
        data:
          {
            id: "1",
            type: "services"
          },
        links: {
          related: "http://test.host/api/v2/services/1.json"
        }
      } }
    end
  end
end
