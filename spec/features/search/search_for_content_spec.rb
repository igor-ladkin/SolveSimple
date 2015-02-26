require_relative '../feature_helper'

feature 'Search for content', %q{
	In order find information about my problem
	As a user
	I want to be able to search for content
} do
	given(:question) { create(:question, body: 'test my app') }

  ThinkingSphinx::Test.run do
		scenario 'search for question', js: true do
			pending
			visit questions_path

			click_on 'Search'
			fill_in 'Search', with: 'test'
			click_on 'Search'

			expect(page).to have_content question.body
		end
  end
end