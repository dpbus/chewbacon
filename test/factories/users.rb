FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Jane #{n}" }
    sequence(:email) { |n| "jane#{n}@example.com" }
    password "password"
  end
end
