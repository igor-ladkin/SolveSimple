require 'rails_helper'

feature 'Editing an answer', %q{
	In order to be able to change my option on a question
	As a user
	I want to edit content of answer's body
} do
	given!(:question) { create(:question) }
	given!(:answer) { create(:answer, question: question) }

	scenario 'with a new valid content' do
		visit question_path(question.id)
		within find('li', text: answer.body) do
			click_on 'Edit'
		end
		fill_in 'Body', with: 'I changed my mind.'
		click_on 'Update Answer'

		expect(page).to have_content 'I changed my mind.'
		expect(current_path).to eq question_path(question.id)
	end

	scenario 'with an invalid new content' do
		visit question_path(question.id)
		within find('li', text: answer.body) do
			click_on 'Edit'
		end
		fill_in 'Body', with: nil
		click_on 'Update Answer'

		expect(page).to have_content "can't be blank"
	end
end