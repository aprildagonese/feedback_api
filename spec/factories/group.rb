FactoryBot.define do
  factory :group do
    survey
    sequence(:name) { |n| "group#{n}" }
  end
end
