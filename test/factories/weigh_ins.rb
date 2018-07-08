FactoryBot.define do
  factory :weigh_in do
    sequence(:weight, 100) { |n| n }
    date { Date.today }
    association :user
  end
end
