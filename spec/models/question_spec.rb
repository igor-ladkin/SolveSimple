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
  it { is_expected.to have_many :votes }
  it { is_expected.to have_many :voted_users }

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

  describe '#rating_in_percent' do
    it 'calculates rating in percentage' do
      allow(subject.votes).to receive(:size).and_return(10)
      allow(subject).to receive(:rating).and_return(5)
      expect(subject.rating_in_percent).to eq ('75')
    end

    it 'returns 0 rating if there is no votes yet' do
      allow(subject.votes).to receive(:size).and_return(0)
      allow(subject).to receive(:rating).and_return(0)
      expect(subject.rating_in_percent).to eq ('0')
    end
  end

  describe '#already_voted_by?' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    subject { create(:question, user: author) }

    it 'returns true if user has already voted for this question' do
      allow(subject.votes).to receive(:where).and_return([user])
      expect(subject.already_voted_by?(user)).to eq true
    end

    it 'returns false if user has not voted for this question' do
      allow(subject.votes).to receive(:where).and_return([])
      expect(subject.already_voted_by?(user)).to eq false
    end
  end
end
