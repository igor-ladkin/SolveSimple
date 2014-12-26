require_relative '../feature_helper'

feature 'Editing an answer', %q{
	In order to be able to change my option on the question
	As a user
	I want to edit content of answer's body
} do
	given!(:author) { create(:user) }
	given!(:user) { create(:user) }
	given!(:question) { create(:question) }
	given!(:answer) { create(:answer, question: question, user: author) }

	context 'Author tries to' do
		scenario 'edit his answer with a new valid content', js: true do
			sign_in author

			visit question_path(question)
			within find('.answer', text: answer.body) do
				click_on 'Edit'
			end
			fill_in 'Body', with: "I've changed my mind."
			click_on 'Update Answer'

			expect(page).to have_content "I've changed my mind."
			expect(current_path).to eq question_path(question.id)
		end

		scenario 'edit his answer with an invalid new content', js: true do
			sign_in author

			visit question_path(question)
			within find('.answer', text: answer.body) do
				click_on 'Edit'
			end
			fill_in 'Body', with: nil
			click_on 'Update Answer'

			expect(page).to have_content "can't be blank"
		end
	end

	context 'User tries to' do
		scenario 'edit the answer from another author' do
			sign_in user

			visit question_path(question)
			within find('.answer', text: answer.body) do
				expect(page).to_not have_selector('.answer-controls')
			end
		end
	end

	context 'Non-authenticated user tries to' do
		scenario 'edit the answer' do
			visit question_path(question)

			expect(page).to_not have_selector('.answer-controls')
		end
	end
end