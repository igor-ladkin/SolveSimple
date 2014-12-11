require 'rails_helper'

RSpec.describe Question, :type => :model do
  it 'has a valid factory' do
  	expect(build(:question)).to be_valid
  end
	
	it 'is invalid without title' do
		expect(build(:question, title: nil)).not_to be_valid
	end  

	it 'is invalid without body' do
		expect(build(:question, body: nil)).not_to be_valid
	end
  #it { should validates_presence_of :title }
  #it { should validates_presence_of :body }
end
