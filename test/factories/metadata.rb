FactoryGirl.define do
  factory :metadata, class: 'ESP::Metadata' do
    skip_create

    sequence(:id) { |n| n }
    type "metadata"
    data { { resource_id: "sg-dae343se4" } }
  end
end
