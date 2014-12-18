require 'rails_helper'

feature 'Editing a question', %q{
	In order to be able to correct the question
	As a user
	I want to change question's title and body
} do
	given!(:user) { create(:user) }
	given!(:question) { create(:question) }

	context 'Authenticated user tries to' do
		scenario 'edit the question with valid parameters' do
			sign_in user

			visit question_path(question.id)
			within('div.jumbotron') do
				click_on 'Edit'
			end
			fill_in 'Title', with: 'Wait!'
			fill_in 'Body', with: "I've changed my mind."
			click_on 'Update Question'

			expect(page).to have_content 'Wait!'
			expect(current_path).to eq question_path(question.id)
		end

		scenario 'edit the question with invalid parameters' do
			sign_in user

			visit question_path(question.id)
			within('div.jumbotron') do
				click_on 'Edit'
			end
			fill_in 'Title', with: nil
			fill_in 'Body', with: "I've changed my mind."
			click_on 'Update Question'

			expect(page).to have_content "can't be blank"
		end
	end

	context 'Non-authenticated user tries to' do
		scenario 'edit the question' do
			visit question_path(question.id)
			within('div.jumbotron') do
				click_on 'Edit'
			end
			
			expect(current_path).to eq new_user_session_path
			expect(page).to have_content 'You need to sign in or sign up before continuing.'
		end
	end
end