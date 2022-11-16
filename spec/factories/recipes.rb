FactoryBot.define do
  factory :recipe do
    sequence(:title) { |n| "Recipe #{n}" }
    sequence(:description) { |n| "Description #{n}" }

  end
end
