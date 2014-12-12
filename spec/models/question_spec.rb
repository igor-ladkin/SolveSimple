require 'rails_helper'

RSpec.describe Question, :type => :model do
  it 'has a valid factory' do
  	expect(build(:question)).to be_valid
  end
	
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to have_many(:answers) }
end
