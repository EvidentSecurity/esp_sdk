FactoryGirl.define do
  factory :service, class: 'ESP::Service' do
    skip_create

    sequence(:id) { |n| n }
    type "services"
    code "S1"
    created_at { Time.current }
    name "SSS"
    updated_at nil
  end
end
