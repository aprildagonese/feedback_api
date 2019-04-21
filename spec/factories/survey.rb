FactoryBot.define do
  factory :survey do
    sequence(:name) { |n| "Survey#{n}" }
  end
end
