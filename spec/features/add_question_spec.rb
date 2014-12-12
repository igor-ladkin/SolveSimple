require 'rails_helper'

feature 'Add question' do
	scenario 'add a new question' do
		expect {
			visit root_path
			click_on 'Ask question'
			fill_in 'Title', with: 'Testing question.'
			fill_in 'Body', with: 'Can you give a simple answer?'
			click_on 'Create Question'
		}.to change(Question, :count).by(1)

		expect(page).to have_content 'Can you give a simple answer?'
	end

	scenario 'add an invalid new question' do
		expect {
			visit root_path
			click_on 'Ask question'
			fill_in 'Title', with: nil
			fill_in 'Body', with: 'Can you give a simple answer?'
			click_on 'Create Question'
		}.to_not change(Question, :count)

		expect(page).to have_content "can't be blank"
	end
end