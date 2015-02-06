require 'rails_helper'

RSpec.describe User, :type => :model do
	it { is_expected.to validate_presence_of :email }
	it { is_expected.to validate_presence_of :password }
	it { is_expected.to have_one :profile }
	it { is_expected.to have_many :questions }
	it { is_expected.to have_many :answers }
	it { is_expected.to have_many :comments }
	it { is_expected.to allow_value('chester@gmail.com').for(:email) }
	it { is_expected.to_not allow_value('change@me-1-facebook.com').for(:email).on(:update) }

	describe '.find_for_oauth' do
		let!(:user) { create(:user) }
		let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

		context 'user already has an authorization' do
			it 'returns the user' do
				user.authorizations.create(provider: 'facebook', uid: '12345')
				expect(User.find_for_oauth(auth)).to eq user
			end
		end

		context 'user has no authorization' do
			context 'but already exists' do
				let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: user.email, verified: true }) }

				it 'does not create new user' do
					expect { User.find_for_oauth(auth) }.to_not change(User, :count)
				end

				it 'creates authorization for user' do
					expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
				end

				it 'creates authorization with provider and uid' do
					authorization = User.find_for_oauth(auth).authorizations.first

					expect(authorization.provider).to eq auth.provider
					expect(authorization.uid).to eq auth.uid
				end

				it 'returns the user' do
					expect(User.find_for_oauth(auth)).to eq user
				end
			end

			context 'and does not exist' do
				let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: 'new@user.com', verified: true }) }
				let(:twitter) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '12345', info: {}) }

				it 'creates new user' do
					expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
				end

				it 'returns new user' do
					expect(User.find_for_oauth(auth)).to be_a(User)
				end

				it "fills user's email if email is provided" do
					user = User.find_for_oauth(auth)
					expect(user.email).to eq auth.info[:email]
				end

				it "generates user's email if email is not provided" do
					user = User.find_for_oauth(twitter)
					expect(user.email).to include "twitter.com"
				end

				it "generates user's email if email is provided but not verified" do
					user = User.find_for_oauth(twitter)
					expect(user.email).to include "twitter.com"
				end

				it 'creates authorization for user' do
					user = User.find_for_oauth(auth)
					expect(user.authorizations).to_not be_empty
				end

				it 'creates authorization with provider and uid' do 
					authorization = User.find_for_oauth(auth).authorizations.first

					expect(authorization.provider).to eq auth.provider
					expect(authorization.uid).to eq auth.uid
				end
			end
		end
	end

	describe '#display_name' do
		context 'user has no profile information' do
			let(:user) { create(:user) }

			it 'returns email' do
				expect(user.display_name).to eq user.email
			end
		end

		context 'user has some profile information' do
			let(:user) { create(:user_with_profile) }

			it 'returns full name' do
				user
				expect(user.display_name).to eq "#{user.first_name} #{user.last_name}"
			end
		end
	end

	describe '.send_daily_digest' do
		let(:users) { create_list(:user, 2) }

		it 'sends daily digest to all users' do
			users.each do |user|
				expect(DailyMailer).to receive(:digest).with(user).and_call_original
			end
			User.send_daily_digest
		end
	end
end