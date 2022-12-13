FactoryBot.define do
  factory :ingredient do
    sequence(:title) { |n| "Ingredient #{n}" }
  end
end
