require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do
	let!(:user) { create(:user) }	
	let!(:question) { create(:question, user: user) }
	let(:comment) { create(:comment, commentable: question, user: @user) }

	describe 'GET #new' do
		sign_in_user

		context 'with AJAX request' do
			before { xhr :get, :new, question_id: question }

			it 'assigns new Comment to @comment' do
				expect(assigns[:comment]).to be_a_new(Comment)
			end

			it 'renders the :new template' do
				expect(response).to render_template :new
			end
		end
	end

	describe 'POST #create' do
		sign_in_user

		context 'with valid attributes' do
			it 'saves the new comment in the database' do
				expect { xhr :post, :create, question_id: question, comment: attributes_for(:comment, user: @user) }.to change(Comment, :count).by(1)
			end

			it 'redirects to questions#show' do
				xhr :post, :create, question_id: question, comment: attributes_for(:comment, user: @user)
				expect(response).to render_template :create
			end
		end
	end

	describe 'GET #edit' do
		sign_in_user

		context 'with AJAX request' do
			before { xhr :get, :edit, id: comment }

			it 'assigns requested comment to @comment' do
				expect(assigns[:comment]).to eq comment
			end

			it 'renders the :edit template' do
				expect(response).to render_template :edit
			end
		end

		context 'with HTTP request' do
			it 'redirects to question#show' do
				get :edit, id: comment
				expect(response).to redirect_to question_path(question)
			end
		end
	end

	describe 'PATCH #update' do
		sign_in_user

		context 'with valid attributes' do
			it 'assigns requested comment to @comment' do
				xhr :patch, :update, id: comment, comment: attributes_for(:comment)
				expect(assigns[:comment]).to eq comment
			end

			it "changes comment's attributes" do
				xhr :patch, :update, id: comment, comment: { body: 'New comment' }
				comment.reload
				expect(comment.body).to eq 'New comment'
			end

			it 'renders the :update template' do
				xhr :patch, :update, id: comment, comment: attributes_for(:comment)
				expect(response).to render_template :update
			end
		end

		context 'with invalid attributes' do
			let(:comment) { create(:comment, commentable: question, body: 'Some old comment', user: @user) }

			before { xhr :patch, :update, id: comment, comment: { body: nil } }

			it "does not change @comment's attributes" do
				comment.reload
				expect(comment.body).to eq 'Some old comment'
			end

			it 're-renders the :edit template' do
				expect(response).to render_template :edit
			end
		end
	end

	describe 'DELETE #destroy' do
		sign_in_user

		before { comment }

		it 'deletes the comment from database' do
			expect { delete :destroy, id: comment }.to change(Comment, :count).by(-1)
		end

		it 'redirects to question#show' do
			delete :destroy, id: comment
			expect(response).to redirect_to question_path(question)
		end
	end
end
