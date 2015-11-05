FactoryGirl.define do
  factory :error, class: 'ActiveResource::Base' do
    skip_create

    errors do
      [{ status: '401',
         title: 'Access Denied' }]
    end

    trait :active_record do
      errors do
        [{ status: '401',
           title: "Name can't be blank",
           meta: { name: "can't be blank" } },
         { status: '401',
           title: "Name is invalid",
           meta: { name: "is invalid" } },
         { status: '401',
           title: "Description can't be blank",
           meta: { description: "can't be blank" } }]
      end
    end
  end
end
