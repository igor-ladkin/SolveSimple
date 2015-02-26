require_relative '../feature_helper.rb'

feature 'Thumbs up', %q{
	In order to increase question's rating
	As a user
	I want to be able to thumbs up that question
} do
	given!(:user) { create(:user) }
	given!(:author) { create(:user) }
	given!(:question) { create(:question, user: author) }

	context 'Authenticated user tries to' do
		scenario "thumbs up another user's question", js: true do
			sign_in user

			visit question_path(question)
			within('#question .voting') do
				find('i.fa-thumbs-o-up').click
			end

			expect(page.find('#question')).to have_css('i.fa-thumbs-o-up.text-success')
			expect(page.find('#question')).to have_css('i.fa-thumbs-o-down.text-muted')
		end

		scenario 'thumbs up question after he thumbs down it', js: true do
			sign_in user

			visit question_path(question)
			within('#question .voting') do
				find('i.fa-thumbs-o-up').click
				find('i.fa-thumbs-o-down').click
			end

			expect(page.find('#question')).to have_css('i.fa-thumbs-o-down.text-danger')
			expect(page.find('#question')).to have_css('i.fa-thumbs-o-up.text-muted')
			expect(page.find('#question')).to_not have_css('i.fa-thumbs-o-up.text-success')
		end
	end

	context 'Author tries to' do
		scenario 'thumbs up his own question', js: true do
			sign_in author

			visit question_path(question)
			within('#question .voting') do
				expect(page).to_not have_css('i.fa-thumbs-o-up')
				expect(page).to_not have_css('i.fa-thumbs-o-down')
			end
		end
	end

	context 'Non-authenticated user tries to' do
		scenario 'thumbs up question', js: true do
			visit question_path(question)
			within('#question .voting') do
				expect(page).to_not have_css('i.fa-thumbs-o-up')
				expect(page).to_not have_css('i.fa-thumbs-o-down')
			end
		end
	end
end