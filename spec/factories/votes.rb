FactoryGirl.define do
  factory :vote do
    status true
    votable { create(:question) }
  end
end
