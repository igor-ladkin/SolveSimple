require 'rails_helper'

feature 'Deleting an answer', %q{
	In order to be able to erase uncorrect answers
	As a user
	I want to delete an answer
} do
	given!(:question) { create(:question) }
	given!(:answer) { create(:answer, question: question) }

	scenario 'with confirmation', js: true do
		expect {
			visit question_path(question.id)
			within find('li', text: answer.body) do
				click_on 'Delete'
			end
			page.accept_alert 'Are you sure?' do
    		click_button('OK')
			end
		}.to change(Answer, :count).by(-1)

		expect(current_path).to eq question_path(question.id)
	end

	scenario 'with cancelation', js: true do
		expect {
			visit question_path(question.id)
			within find('li', text: answer.body) do
				click_on 'Delete'
			end
			page.driver.browser.alert.dismiss
		}.to_not change(Answer, :count)

		expect(current_path).to eq question_path(question.id)
	end
end