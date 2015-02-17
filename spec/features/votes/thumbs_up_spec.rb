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
		scenario "thumbs up another user's question" do
			sign_in user

			visit question_path(question)
			within('#question .voting') do
				find('i.fa-thumbs-o-up').click
			end

			save_and_open_page

			expect(page).to have_css('i.text-muted')
		end

		scenario 'thumbs up question twice' do
			sign_in user

			visit question_path(question)
			within('#question .voting') do
				find('i.fa-thumbs-o-up').click
			end

			visit question_path(question)

			expect(page.find('#question a.disabled').count).to eq 2
			expect(page.find('#question')).to have_css('i.fa-thumbs-o-up.text-success')
			expect(page.find('#question')).to have_css('i.fa-thumbs-o-down.text-muted')
		end
		scenario 'thumbs up question after he thumbs down it'
	end

	context 'Author tries to' do
		scenario 'thumbs up his own question'
	end

	context 'Non-authenticated user tries to' do
		scenario 'thumbs up question'
	end
end