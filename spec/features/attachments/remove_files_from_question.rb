require_relative '../feature_helper'

feature 'Remove files from question', %q{
	In order to give more details about the problem
	As an author
	I want to attach files
}, js: true do
	pending
	given!(:author) { create(:user) }
	given(:question) { create(:question, user: author) }

	background do
		sign_in author
		visit root_path
		click_on 'Ask Question'
	end

	scenario 'User adds file when asks question' do
		fill_in 'Title', with: question.title
		fill_in 'Body', with: question.body
		attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
		click_on 'Create Question'

		expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
	end
end