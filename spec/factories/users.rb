FactoryBot.define do
  factory :user do
    sequence(:username) {|n| "user #{n}"}
    sequence(:email) {|n| "email#{n}@mail.ru"}
    password { "MyString" }
  end
end
