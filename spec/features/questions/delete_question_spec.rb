require_relative '../feature_helper'

feature 'Deleting a question', %q{
	In order to be able to erase an inaccurate question
	As a user
	I want to delete a question
} do
	given!(:user) { create(:user) }
	given!(:question) { create(:question, user: user) }

	context 'Author tries to' do
		scenario 'delete his question', js: true do
			sign_in user

			visit question_path(question)
			within('.question-controls') do
				click_on 'Delete'
			end

			expect(page).to_not have_content(question.body)
			expect(current_path).to eq questions_path
		end
	end

	context 'User tries to' do
		scenario 'delete a question from another author', js: true do
			sign_in user

			visit question_path(question)

			expect(page).to_not have_selector('.question-controls')
		end
	end

	context 'Non-authenticated user tries to' do
		scenario 'delete a question', js: true do
			visit question_path(question)

			expect(page).to_not have_selector('.question-controls')
		end
	end
end