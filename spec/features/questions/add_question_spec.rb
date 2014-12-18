require 'rails_helper'

feature 'Add question', %q{
	In order to get answer from community
	As a user
	I want to be able to ask a question
} do
	given!(:user) { create(:user) }

	context 'Authenticated user tries to' do
		scenario 'add a new question' do
			sign_in user

			visit questions_path
			click_on 'Ask question'
			fill_in 'Title', with: 'Testing question.'
			fill_in 'Body', with: 'Can you give a simple answer?'
			click_on 'Create Question'

			expect(page).to have_content 'Your question was successfully created.'
			expect(page).to have_content 'Can you give a simple answer?'
		end

		scenario 'add an invalid new question' do
			sign_in user

			visit questions_path
			click_on 'Ask question'
			fill_in 'Title', with: nil
			fill_in 'Body', with: 'Can you give a simple answer?'
			click_on 'Create Question'

			expect(page).to have_content "can't be blank"
		end
	end

	context 'Non-authenticated user tries to' do
		scenario 'add a new question' do
			visit questions_path
			click_on 'Ask question'

			expect(current_path).to eq new_user_session_path
			expect(page).to have_content 'You need to sign in or sign up before continuing.'
		end
	end
end