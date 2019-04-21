FactoryBot.define do
  factory :answer do
    question
    value { 4 }
    sequence(:description) { "This person used excellent communication." }
  end
end
