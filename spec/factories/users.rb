FactoryGirl.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password 'secret123'
    password_confirmation 'secret123'
    confirmed_at Time.now

    factory :user_with_profile do
    	profile { create(:profile) }
    end
  end
end
