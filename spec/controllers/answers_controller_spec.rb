require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
	let!(:question) { create(:question) }
	let(:answer) { create(:answer, question: question) }

	describe 'GET #new' do
		before { get :new, question_id: question.id  }

		it 'assigns new answer to @answer' do
			expect(assigns[:answer]).to be_a_new(Answer)
		end

		it 'renders the :new template' do
			expect(response).to render_template :new
		end
	end

	describe 'POST #create' do
		context 'with valid attributes' do
			it 'saves the new answer to the question in the database' do
				expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
			end

			it 'redirects to question#show' do
				post :create, question_id: question.id, answer: attributes_for(:answer)
				expect(response).to redirect_to question_path(question.id)
			end
		end

		context 'with invalid attributes' do
			it 'does not save the new answer in the database' do
				expect { post :create, question_id: question.id, answer: attributes_for(:answer, body: nil) }.to_not change(Answer, :count)
			end

			it 're-renders the :new template' do
				post :create, question_id: question.id, answer: attributes_for(:answer, body: nil)
				expect(response).to render_template :new
			end
		end
	end
end
