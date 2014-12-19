require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
	let!(:question) { create(:question) }
	let!(:author) { create(:user) }
	let(:user) { create(:user) }
	let(:answer) { create(:answer, question: question, user: @user) }

	shared_examples 'private access to answers' do
		describe 'GET #new' do
			sign_in_user

			before { get :new, question_id: question.id  }

			it 'assigns new answer to @answer' do
				expect(assigns[:answer]).to be_a_new(Answer)
			end

			it 'renders the :new template' do
				expect(response).to render_template :new
			end
		end

		describe 'POST #create' do
			sign_in_user

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

	shared_examples 'full access to answers' do
		describe 'GET #edit' do
			sign_in_user

			before { get :edit, question_id: question, id: answer }

			it 'assigns requested answer to @answer' do
				expect(assigns[:answer]).to eq answer
			end

			it 'renders the :edit template' do
				expect(response).to render_template :edit
			end
		end

		describe 'PATCH #update' do
			sign_in_user

			context 'with valid attributes' do
				it 'assigns requested answer to @answer' do
					patch :update, question_id: question.id, id: answer, answer: attributes_for(:answer)
					expect(assigns[:answer]).to eq answer
				end

				it "changes @answer's attributes" do
					patch :update, question_id: question.id, id: answer, answer: { body: 'New body' }
					answer.reload
					expect(answer.body).to eq 'New body'
				end

				it "redirects to question's page" do
					patch :update, question_id: question.id, id: answer, answer: attributes_for(:answer)
					expect(response).to redirect_to question_path(question.id)
				end
			end

			context 'with invalid attributes' do
				let(:answer) { create(:answer, question: question, body: 'Some old answer') }

				before { patch :update, question_id: question.id, id: answer, answer: { body: nil } }

				it "does not change @answer's attributes" do
					answer.reload
					expect(answer.body).to eq 'Some old answer'
				end

				it 're-renders the :edit template' do
					expect(response).to render_template :edit
				end
			end
		end

		describe 'DELETE #destroy' do
			sign_in_user

			before { answer }

			it 'deletes the answer from the database' do
				expect { delete :destroy, question_id: question.id, id: answer }.to change(Answer, :count).by(-1)
			end

			it 'redirects to question#show' do
				delete :destroy, question_id: question.id, id: answer
				expect(response).to redirect_to question_path(question.id)
			end
		end
	end

	context 'user access to answers' do
		it_behaves_like 'private access to answers'
	end

	context 'author access to answers' do
		it_behaves_like 'private access to answers'
		it_behaves_like 'full access to answers'
	end

	context 'guest access to answers' do
		describe 'GET #new' do
			it 'requires login' do
				get :new, question_id: question.id
			end
		end

		describe 'POST #create' do
			it 'requires login' do
				post :create, question_id: question.id, answer: attributes_for(:answer)
			end
		end

		describe 'GET #edit' do
			it 'requires login' do
				get :edit, question_id: question.id, id: answer
			end
		end

		describe 'PATCH #update' do
			it 'requires login' do
				patch :update, question_id: question.id, id: answer, answer: attributes_for(:answer)
			end
		end

		describe 'DELETE #destroy' do
			it 'requires login' do
				delete :destroy, question_id: question.id, id: answer
			end
		end

		after { expect(response).to require_login }
	end
end
