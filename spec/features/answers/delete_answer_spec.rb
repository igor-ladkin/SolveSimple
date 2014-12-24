require_relative '../feature_helper'

feature 'Deleting an answer', %q{
	In order to be able to erase incorrect answers
	As a user
	I want to delete an answer
} do
	given!(:user) { create(:user) }
	given!(:question) { create(:question, user: user) }
	given!(:answer) { create(:answer, question: question, user: user) }

	context 'Authenticated user tries to' do
		scenario 'delete an answer', js: true do
			sign_in user

			visit question_path(question)
			within find('li', text: answer.body) do
				click_on 'Delete'
			end

			expect(page).to_not have_content(answer.body)
			expect(current_path).to eq question_path(question)
		end
	end

	context 'Non-authenticated user tries to' do
		scenario 'delete an answer', js: true do
			visit question_path(question)

			expect(page).to_not have_selector('.answer-controls')
		end
	end
end