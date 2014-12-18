require 'rails_helper'

feature 'Add answer', %q{
	In order to help with solving problem
	As a user
	I want to be able to add my answer to a specific question
} do
	given!(:question) { create(:question) }

	context 'Authenticated user tries to' do
		scenario 'add a new answer' do
			visit question_path(question.id)
			click_on 'Answer'
			fill_in 'Body', with: 'In my opinion this is not relevant.'
			click_on 'Create Answer'

			expect(current_path).to eq question_path(question.id)
			expect(page).to have_content 'In my opinion this is not relevant.'
		end

		scenario 'add an invalid new answer' do
			visit question_path(question.id)
			click_on 'Answer'
			fill_in 'Body', with: nil
			click_on 'Create Answer'

			expect(page).to have_content "can't be blank"
		end
	end

	context 'Non-authenticated user tries to' do
		scenario 'add a new answer' do
			visit question_path(question.id)
			click_on 'Answer'

			expect(current_path).to eq new_user_session_path
			expect(page).to have_content 'You need to sign in or sign up before continuing.'
		end
	end
end
