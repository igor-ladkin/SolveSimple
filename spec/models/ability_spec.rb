require 'rails_helper'

RSpec.describe Ability do
	subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
 
    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }
 
    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }
    it { is_expected.to be_able_to :create, Comment }
 
    it { is_expected.to be_able_to :update, create(:question, user: user), user: user }
    it { is_expected.to_not be_able_to :update, create(:question, user: other), user: user }
 
    it { is_expected.to be_able_to :update, create(:answer, user: user), user: user }
    it { is_expected.to_not be_able_to :update, create(:answer, user: other), user: user }

    it { is_expected.to be_able_to :update, create(:comment, user: user), user: user }
    it { is_expected.to_not be_able_to :update, create(:comment, user: other), user: user }

    it { is_expected.to be_able_to :destroy, create(:question, user: user), user: user }
    it { is_expected.to_not be_able_to :destroy, create(:question, user: other), user: user }
 
    it { is_expected.to be_able_to :destroy, create(:answer, user: user), user: user }
    it { is_expected.to_not be_able_to :destroy, create(:answer, user: other), user: user }

    it { is_expected.to be_able_to :destroy, create(:comment, user: user), user: user }
    it { is_expected.to_not be_able_to :destroy, create(:comment, user: other), user: user }
  end
end
