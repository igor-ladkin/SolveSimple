require 'rails_helper'

feature 'User registration', %q{
	In order to get full user experience of using a system
	As a guest
	I want to be able to register
} do

	given!(:existing_user) { create(:user) }
	given(:new_user) { build(:user) }

	background do
			visit root_path
			click_on 'Sign up'
	end

	context 'Guest tries to register' do
		scenario 'with a valid password and correct confimation' do
			fill_in 'Email', with: new_user.email
			find('.user_password').fill_in 'Password', with: new_user.password
			find('.user_password_confirmation').fill_in 'Password confirmation', with: new_user.password
			click_button 'Sign up'

			expect(page).to have_content('Welcome! You have signed up successfully.')
			expect(current_path).to eq root_path
		end

		scenario 'with an invalid parameters' do
			fill_in 'Email', with: existing_user.email
			find('.user_password').fill_in 'Password', with: '123'
			find('.user_password_confirmation').fill_in 'Password confirmation', with: 'secret123'
			click_button 'Sign up'

			save_and_open_page
			expect(page).to have_content('has already been taken')
			expect(page).to have_content('is too short (minimum is 8 characters)')
			expect(page).to have_content("doesn't match Password") 
		end
	end
end