require_relative '../feature_helper.rb'

feature 'Add comment', %q{
	In order to express my opinion on record
	As a user
	I want to be able to leave comments on questions and answers
} do
	given!(:user) { create(:user) }
	given!(:question) { create(:question, user: user) }
	given!(:answer) { create(:answer, question: question, user: user) }

	context 'Authenticated user tries to' do
		scenario 'add a new comment to question', js: true do
			sign_in(user)

			visit question_path(question)
			within('#question') do
				click_on 'Leave Comment'
			end
			
			fill_in 'Body', with: 'My first comment'
			click_on 'Create Comment'

			expect(page).to have_content 'Your comment was successfully created.'
			expect(page).to have_content 'My first comment.'
		end
		scenario 'add a new comment to answer'
		scenario 'add an invalid comment to question'
		scenario 'add an invalid comment to answer'
	end

	context 'Non-authenticated user tries to' do
	end
end