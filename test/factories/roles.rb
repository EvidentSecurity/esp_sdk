FactoryGirl.define do
  factory :role, class: 'ESP::Role' do
    skip_create

    sequence(:id) { |n| n }
    type "roles"
    name "customer"
  end
end
