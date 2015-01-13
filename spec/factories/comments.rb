FactoryGirl.define do
  factory :comment do
		body { Faker::Lorem.paragraph }

		factory :invalid_comment do
			body nil
		end
  end

end
