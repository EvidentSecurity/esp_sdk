FactoryGirl.define do
  factory :cloud_trail_event, class: 'ESP::CloudTrailEvent' do
    skip_create

    sequence(:id) { |n| n }
    type "cloud_trail_events"
    title "test2"
    event_id "1"
    event_name "1"
    event_time "2015-10-16T19:07:24.434Z"
    raw_event { { test: "event data" } }
    username "johndoe"
    ip_address "123.0.0.123"
    user_agent "Chrome"
  end
end
