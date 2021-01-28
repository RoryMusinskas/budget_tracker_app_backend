FactoryBot.define do 
  # the minimum that this model can be ( as it doesn't matter if the shares_preferences is there, we exclude it )
  factory :user do
    sequence :email do |n| 
      "Email#{n}@test.com"
    end

    trait :invalid do
      email {nil}
    end

  end
end
