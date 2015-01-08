require 'rails_helper'

RSpec.describe User, :type => :model do
	it { is_expected.to validate_presence_of :email }
	it { is_expected.to validate_presence_of :password }
	it { is_expected.to have_many :questions }
	it { is_expected.to have_many :answers }
	it { is_expected.to have_many :comments }
end