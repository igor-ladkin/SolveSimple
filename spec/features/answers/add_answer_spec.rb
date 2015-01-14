require_relative '../feature_helper'

feature 'Add answer', %q{
	In order to help with solving problem
	As a user
	I want to be able to add my answer to a specific question
} do
	given!(:user) { create(:user) }
	given!(:question) { create(:question) }

	context 'Authenticated user tries to' do
		scenario 'add a new answer', js: true do
			sign_in user

			visit question_path(question)
			click_on 'Add answer'
			fill_in 'Body', with: 'In my opinion this is not relevant.'
			click_on 'Create answer'

			expect(page).to have_content 'Your answer was successfully created.'
			within '#answers' do
				expect(page).to have_content 'In my opinion this is not relevant.'
			end
			expect(current_path).to eq question_path(question.id)
		end

		scenario 'add an invalid new answer', js: true do
			sign_in user
			
			visit question_path(question)
			click_on 'Add answer'
			fill_in 'Body', with: nil
			click_on 'Create answer'

			expect(page).to have_content "can't be blank"
		end
	end

	context 'Non-authenticated user tries to', js: true do
		scenario 'add a new answer' do
			visit question_path(question)

			expect(page).not_to have_link 'Add answer'
		end
	end
end
