FactoryBot.define do
  factory :group do
    name "Test Group"
    start_date { 1.week.ago }
    end_date { 1.week.from_now }
  end
end
