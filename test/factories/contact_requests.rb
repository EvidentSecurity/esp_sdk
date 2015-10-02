FactoryGirl.define do
  factory :cloud_trail_event, class: 'ESP::CloudTrailEvent' do
    skip_create

    sequence(:id) { |n| n }
    type "cloud_trail_events"
    event_id "1"
    event_name "1"
    event_time { Time.current }
    username "johndoe"
    ip_address "123.0.0.123"
    user_agent "Chrome"
  end
end
