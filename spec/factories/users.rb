FactoryGirl.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password 'secret123'
    password_confirmation 'secret123'
  end
end
