FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User#{n}" }
  end

  factory :response_user, parent: :user do
  end

  factory :target_user, parent: :user do
  end
end
