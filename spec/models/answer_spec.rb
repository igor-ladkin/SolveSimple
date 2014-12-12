require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it 'has a valid factory' do
  	expect(build(:answer)).to be_valid
  end

  it 'is invalid without body' do
  	expect(build(:invalid_answer)).not_to be_valid
  end

  context 'association with question' do
  	let(:question) { create(:question) }
  	let(:answer) { question.answers.create(attributes_for(:answer)) }

  	it 'belongs to question' do

  		expect(question.answers).to include answer
  	end

  	it 'is invalid without question'
  end
end
