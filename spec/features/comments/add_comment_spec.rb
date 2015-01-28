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
				click_on 'Leave comment'
			end
			
			fill_in 'Body', with: 'My first comment to question.'
			click_on 'Create comment'

			expect(page).to have_content 'Your comment was successfully created.'
			expect(page).to have_content 'My first comment to question.'
		end

		scenario 'add a new comment to answer', js: true do
			sign_in(user)

			visit question_path(question)
			within('.answer') do
				click_on 'Leave comment'
			end
			
			fill_in 'Body', with: 'My first comment to answer.'
			click_on 'Create comment'

			expect(page).to have_content 'Your comment was successfully created.'
			expect(page).to have_content 'My first comment to answer.'
		end

		scenario 'add an invalid comment to question', js: true do
			sign_in(user)

			visit question_path(question)
			within('#question') do
				click_on 'Leave comment'
			end
			
			fill_in 'Body', with: nil
			click_on 'Create comment'

			expect(page).to have_content "can't be blank"
		end

		scenario 'add an invalid comment to answer', js: true do
			sign_in(user)

			visit question_path(question)
			within('.answer') do
				click_on 'Leave comment'
			end
			
			fill_in 'Body', with: nil
			click_on 'Create comment'

			expect(page).to have_content "can't be blank"
		end
	end

	context 'Non-authenticated user tries to' do
		scenario 'add a new comment', js: true do
			visit question_path(question)

			expect(page).to_not have_link 'Leave comment'
		end
	end
end