require 'rails_helper'

RSpec.describe Question, :type => :model do
  it 'has a valid factory' do
  	expect(build(:question)).to be_valid
  end
	
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :answers }
  it { is_expected.to have_many :attachments }
  it { is_expected.to have_many :comments }
  it { is_expected.to accept_nested_attributes_for :attachments }
  it { is_expected.to have_and_belong_to_many :tags }

  describe '#solution' do
    let!(:question) { create(:question) }
    let!(:approved_answer) { create(:answer, question: question, approved: true) }

    it 'returns an approved answer as a solution to the question' do
      expect(question.solution).to eq approved_answer
    end
  end

  describe '.tagged_with' do
    let!(:question) { create(:question) }
    let!(:question_with_tags) { create(:question_with_tags) }

    it 'returns an array of questions with tag' do
      expect(Question.tagged_with('pizza')).to include question_with_tags
    end

    it 'does not include question without tag' do
      expect(Question.tagged_with('pizza')).to_not include question
    end
  end
end
