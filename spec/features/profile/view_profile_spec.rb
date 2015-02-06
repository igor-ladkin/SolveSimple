require_relative '../feature_helper'

feature 'View profile page', %q{
	In order to look information about my profile
	As a user
	I want to be able to visit my profile page
} do
	given!(:user) { create(:user_with_profile) }

	context 'Authenticated user tries to' do
		scenario 'visit his profile page' do
			sign_in user

			visit root_path
			within('#navbar') do
				click_on "Hello #{user.display_name}"
			end

			expect(page).to have_content("Hello, my name is #{user.display_name}")
		end
	end

	context 'Non-authenticated user tries to' do
		scenario 'visit profile page' do
			visit root_path

			within('#navbar') do
				expect(page).to_not have_link("Hello #{user.display_name}")
			end
		end
	end
end