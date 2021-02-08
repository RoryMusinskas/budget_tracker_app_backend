FactoryBot.define do
  factory :expense do
    description {'first expense'}
    amount {100}
    association :category
    user_sub {'user_sub'}
    title {'expense'}
    date {'02/02/2021'}
  end
end
