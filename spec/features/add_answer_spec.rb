require 'rails_helper'

feature 'Add answer' do
	given!(:question) { create(:question) }

	scenario 'add a new answer' do
		expect{
			visit question_path(question.id)
			click_on 'Answer'
			fill_in 'Body', with: 'In my opinion this is not relevant.'
			click_on 'Create Answer'
		}.to change(Answer, :count).by(1)

		expect(current_path).to eq question_path(question.id)
		expect(page).to have_content 'In my opinion this is not relevant.'
	end

	scenario 'add an invalid new answer' do
		expect {
			visit question_path(question.id)
			click_on 'Answer'
			fill_in 'Body', with: nil
			click_on 'Create Answer'
		}.to_not change(Answer, :count)

		expect(page).to have_content "can't be blank"
	end
end
