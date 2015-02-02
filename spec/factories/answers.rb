FactoryGirl.define do
  factory :answer do
    body { Faker::Hacker.say_something_smart }
    approved false

    factory :invalid_answer do
    	body nil
    end

    factory :solution do
    	approved true
    end
  end
end
