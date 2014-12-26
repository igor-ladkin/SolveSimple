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
  it { is_expected.to accept_nested_attributes_for :attachments }
end
