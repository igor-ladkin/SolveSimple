require_relative '../feature_helper'

feature 'Search for content', %q{
	In order find similar questions
	As a user
	I want to be able to search by tag
} do
	given!(:question) { create(:question) }
	given!(:question_with_tags) { create(:question_with_tags) }
	
	context 'from main page' do
		scenario 'search for questions by tag', js: true do
			visit questions_path

			within('.tags') do
				click_on 'pizza'
			end

			expect(page).to have_content(question_with_tags.title)
			expect(page).to_not have_content(question.title)
		end
	end

	context 'from question page' do
		given!(:another_question_with_tags) { create(:question_with_tags) }
		
		scenario 'search for question by tag', js: true do
			visit questions_path

			save_and_open_page

			visit question_path(question_with_tags)

			save_and_open_page

			within('#tags') do
				click_on 'pizza'
			end

			save_and_open_page

			expect(page).to have_content(question_with_tags.title)
			expect(page).to have_content(another_question_with_tags.title)
			expect(page).to_not have_content(question.title)
		end
	end
end