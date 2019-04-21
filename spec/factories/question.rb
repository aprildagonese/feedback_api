FactoryBot.define do
  factory :question do
    sequence(:text) { |n| "#{n} How did this teammate communicate?" }
  end
end
