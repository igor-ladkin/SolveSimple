require_relative '../feature_helper'

feature 'Editing a question', %q{
	In order to be able to correct the question
	As a user
	I want to change question's title and body
} do
	given!(:author) { create(:user) }
	given!(:user) { create(:user) }
	given!(:question) { create(:question, user: author) }

	context 'Author tries to' do
		scenario 'edit his question with valid parameters', js: true do
			sign_in author

			visit question_path(question)
			within('.question-controls') do
				click_on 'Edit'
			end
			fill_in 'Title', with: 'Wait!'
			fill_in 'Body', with: "I've changed my mind."
			click_on 'Update Question'

			expect(page).to have_content 'Wait!'
			expect(current_path).to eq question_path(question)
		end

		scenario 'edit his question with invalid parameters', js: true do
			sign_in author

			visit question_path(question)
			within('.question-controls') do
				click_on 'Edit'
			end
			fill_in 'Title', with: nil
			fill_in 'Body', with: "I've changed my mind."
			click_on 'Update Question'

			expect(page).to have_content "can't be blank"
		end
	end

	context 'User tries to' do
		scenario 'edit the question from another author', js: true do
			pending
			sign_in user

			visit question_path(question)

			expect(page).to_not have_selector('.question-controls')
		end
	end

	context 'Guest tries to' do
		scenario 'edit the question', js: true do
			visit question_path(question)
			
			expect(page).to_not have_selector('.question-controls')
		end
	end
end