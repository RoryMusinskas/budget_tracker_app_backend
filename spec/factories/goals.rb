FactoryBot.define do
  factory :goal do
    user_sub {'user_sub'}
    goals_data {{goals: ['goal-1']}}
  end
end