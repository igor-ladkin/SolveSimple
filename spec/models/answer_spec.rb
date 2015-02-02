require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it 'has a valid factory' do
  	expect(build(:answer)).to be_valid
  end

  it { is_expected.to validate_presence_of :body }
  it { is_expected.to belong_to :question }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :attachments }
  it { is_expected.to have_many :comments }
  it { is_expected.to accept_nested_attributes_for :attachments }

  describe '.approve' do
  	let(:question) { create(:question) }
  	let!(:answer) { create(:answer, question: question) }
  	let!(:previous_answer) { create(:answer, question: question, approved: true) }

  	context 'question has no previous solution' do
  		it "sets answer's approved status to true" do
  			answer.approve
  			expect(answer.approved).to eq true
  		end
  	end

  	context 'question has previous solution' do
  		it "removes previous solution's approved status" do
  			expect{ answer.approve }.to change{ previous_answer.reload.approved }.from(true).to(false)
  		end

  		it "sets answer's approved status to true" do
  			answer.approve
  			expect(answer.approved).to eq true
  		end

  		it "keeps answer's status to true if author tries to approve the same answer" do
  			expect{ previous_answer.approve }.to_not change{ previous_answer.reload.approved }
  		end
  	end
  end
end
