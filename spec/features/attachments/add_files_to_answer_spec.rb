require_relative '../feature_helper'

feature 'Attach files to answer', %q{
	In order to illustrate my answer
	As an author
	I want to attach files
}, js: true do
	given!(:author) { create(:user) }
	given!(:question) { create(:question, user: author) }
	given(:answer) { build(:answer, question: question, user: author) }

	background do
		sign_in author
		visit question_path(question)
		click_on 'Add answer'
	end

	scenario 'User adds file when adds answer' do
		pending
		fill_in 'Body', with: answer.body
		# find('#answer_attachments_attributes_0_file', visible: false).set "#{Rails.root}/spec/spec_helper.rb"
		attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
		click_on 'Create answer'

		within '#answers' do
			expect(page).to have_link 'spec_helper.rb', href: "#{Rails.root}/spec/support/uploads/attachment/file/1/spec_helper.rb"
		end
	end
end