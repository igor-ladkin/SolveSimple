require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it 'has a valid factory' do
  	expect(build(:answer)).to be_valid
  end

  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user) }
end
