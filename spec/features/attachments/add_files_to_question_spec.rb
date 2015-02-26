require_relative '../feature_helper'

feature 'Attach files to question', %q{
	In order to give more details about the problem
	As an author
	I want to attach files
}, js: true do
	given!(:author) { create(:user) }
	given(:question) { create(:question, user: author) }

	scenario 'User adds file when asks question' do
		pending 
		sign_in author
		visit root_path
		click_on 'Ask question'

		fill_in 'Title', with: question.title
		fill_in 'Body', with: question.body
		attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
		click_on 'Create question'

		expect(page).to have_link 'spec_helper.rb', href: "#{Rails.root}/spec/support/uploads/attachment/file/1/spec_helper.rb"
	end
end