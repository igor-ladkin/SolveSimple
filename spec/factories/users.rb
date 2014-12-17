FactoryGirl.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password 'secret'
    password_confirmation 'secret'
  end
end
