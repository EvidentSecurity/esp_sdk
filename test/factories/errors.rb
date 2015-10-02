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
           message: { name: ["can't be blank", "is invalid"] } },
         { status: '401',
           title: "Description can't be blank",
           message: { description: ["can't be blank"] } }]
      end
    end
  end
end
