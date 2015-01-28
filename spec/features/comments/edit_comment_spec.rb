require_relative '../feature_helper.rb'

feature 'Edit comment', %q{
	In order to correct my opinion on record
	As a user
	I want to be able to edit comments on questions and answers
} do
	given!(:user) { create(:user) }
	given!(:question) { create(:question, user: user) }
	given!(:answer) { create(:answer, question: question, user: user) }
	given!(:comment) { create(:comment, commentable: question, user: user) }

	context 'Authenticated user tries to' do
		scenario 'edit his comment to question', js: true do
			sign_in(user)

			visit question_path(question)
			within find('.comment', text: comment.body) do
				find('i.fa-paint-brush').click
			end
			
			fill_in 'Body', with: 'NOPE!'
			click_on 'Update comment'

			expect(page).to have_content 'Your comment was successfully updated.'
			expect(page).to have_content 'NOPE!'
		end

		scenario 'edit his commnet with an invalid data', js: true do
			sign_in(user)

			visit question_path(question)
			within find('.comment', text: comment.body) do
				find('i.fa-paint-brush').click
			end
			
			fill_in 'Body', with: nil
			click_on 'Update comment'

			expect(page).to have_content "can't be blank"
		end
	end

	context 'Non-authenticated user tries to' do
		scenario 'edit comment' do
			visit question_path(question)

			expect(page).to_not have_css('i.fa-paint-brush')
		end
	end
end