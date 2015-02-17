require 'rails_helper'

RSpec.describe Vote, :type => :model do
	subject { build(:vote) }

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :votable }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type]) }

  it 'calculates rating after save' do
  	expect(subject).to receive(:calculate_votable_rating)
  	subject.save!
  end
end
