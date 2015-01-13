require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do
	let!(:user) { create(:user) }	
	let(:question) { create(:question, user: user) }

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
end
