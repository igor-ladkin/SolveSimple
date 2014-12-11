FactoryGirl.define do
  factory :question do
    title { Faker::Hacker.say_something_smart }
		body { Faker::Lorem.paragraph }

		factory :invalid_question do
			title nil
		end
  end
end
