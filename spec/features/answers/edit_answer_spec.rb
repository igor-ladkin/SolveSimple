require 'rails_helper'

feature 'Editing an answer', %q{
	In order to be able to change my option on the question
	As a user
	I want to edit content of answer's body
} do
	given!(:user) { create(:user) }
	given!(:question) { create(:question) }
	given!(:answer) { create(:answer, question: question) }

	scenario 'with a new valid content' do
		sign_in user

		visit question_path(question.id)
		within find('.answer', text: answer.body) do
			click_on 'Edit'
		end
		fill_in 'Body', with: "I've changed my mind."
		click_on 'Update Answer'

		expect(page).to have_content "I've changed my mind."
		expect(current_path).to eq question_path(question.id)
	end

	scenario 'with an invalid new content' do
		sign_in user

		visit question_path(question.id)
		within find('.answer', text: answer.body) do
			click_on 'Edit'
		end
		fill_in 'Body', with: nil
		click_on 'Update Answer'

		expect(page).to have_content "can't be blank"
	end
end