require_relative '../feature_helper'

feature 'Add question', %q{
	In order to approve one answer from community
	As a author
	I want to be able to mark question as solved
} do
	given!(:author) { create(:user) }
	given!(:user) { create(:user) }
	given!(:question) { create(:question, user: author) }
	given!(:answer) { create(:answer, question: question, user: user) }

	context 'Authenticated author of a question tries to' do
		scenario "approve another user's answer to own question", js: true do
			sign_in author

			visit question_path(question)
			within find('.answer', text: answer.body) do
				find('i.fa-check').click
			end

			expect(page).to have_css(".approved")
			expect(page).to have_content 'You have successfully approved an answer to your question.'
		end
	end

	context 'Authenticated author of an answer but not a question tries to' do
		scenario 'approve an answer' do
			sign_in user

			visit question_path(question)

			expect(page).to_not have_css('i.fa-check')
		end
	end

	context 'Non-authenticated user tries to' do
		scenario 'approve an answer' do
			visit question_path(question)

			expect(page).to_not have_css('i.fa-check')
		end
	end
end