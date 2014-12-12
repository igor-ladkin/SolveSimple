FactoryGirl.define do
  factory :answer do
    body { Faker::Hacker.say_something_smart }

    factory :invalid_answer do
    	body nil
    end
  end
end
