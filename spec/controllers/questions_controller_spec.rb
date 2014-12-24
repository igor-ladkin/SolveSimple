require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
	let!(:user) { create(:user) }	
	let(:question) { create(:question, user: user) }

	describe 'GET #index' do
		let(:questions) { create_list(:question, 2) }
		let(:latest_question) { create(:question) }

		before { get :index }

		it 'populates an array of all questions' do
			expect(assigns(:questions)).to match_array(questions)
		end

		it 'displays questions according their date of creation in a descending order' do
			expect(assigns(:questions)).to eq questions.reverse.unshift(latest_question)
		end

		it 'renders the :index template' do
			expect(response).to render_template :index
		end
	end

	describe 'GET #show' do
		before { get :show, id: question }

		it 'assigns requested question to @question' do
			expect(assigns(:question)).to eq question
		end

		it 'renders the :show template' do
			expect(response).to render_template :show
		end
	end

	describe 'GET #new' do
		sign_in_user

		context 'with AJAX request' do
			before { xhr :get, :new }

			it 'assigns new Question to @question' do
				expect(assigns[:question]).to be_a_new(Question)
			end

			it 'renders the :new template' do
				expect(response).to render_template :new
			end
		end

		context 'with HTTP request' do
			it 'redirects to root path' do
				get :new
				expect(response).to redirect_to(root_path)
			end
		end
	end

	describe 'GET #edit' do
		sign_in_user

		context 'with AJAX request' do
			before { xhr :get, :edit, id: question }

			it 'assigns requested question to @question' do
				expect(assigns(:question)).to eq question
			end

			it 'renders the :edit template' do
				expect(response).to render_template :edit
			end
		end

		context 'with HTTP request' do
			it 'redirects to question path' do
				get :edit, id: question
				expect(response).to redirect_to(question_path(question))
			end
		end
	end

	describe 'POST #create' do
		sign_in_user

		context 'with valid attributes' do
			it 'saves the new question in the database' do
				expect { xhr :post, :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
			end

			it 'redirects to questions#show' do
				xhr :post, :create, question: attributes_for(:question)
				expect(response).to render_template :create
			end
		end

		context 'with invlid attributes' do
			it 'does not save the new question in the database' do
				expect { xhr :post, :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
			end

			it 're-renders the :new template' do
				xhr :post, :create, question: attributes_for(:invalid_question)
				expect(response).to render_template :new
			end
		end
	end

	describe 'PATCH #update' do
		sign_in_user

		context 'with valid attributes' do
			it 'assigns requested question to @question' do
				xhr :patch, :update, id: question, question: attributes_for(:question)
				expect(assigns(:question)).to eq question
			end

			it "changes @question's attributes" do
				xhr :patch, :update, id: question, question: { title: 'New Title', body: 'New body' }
				question.reload
				expect(question.title).to eq 'New Title'
				expect(question.body).to eq 'New body'
			end

			it 'renders the :update template' do
				xhr :patch, :update, id: question, question: attributes_for(:question)
				expect(response).to render_template :update
			end
		end

		context 'with invalid attributes' do
			let(:question) { create(:question, body: 'Some old body') }

			before { xhr :patch, :update, id: question, question: { title: 'New Title', body: nil } }

			it "does not change @question's attributes" do
				question.reload
				expect(question.title).to_not eq 'New Title'
				expect(question.body).to eq 'Some old body'
			end

			it 're-renders the :edit template' do
				expect(response).to render_template :edit
			end
		end
	end

	describe 'DELETE #destroy' do
		sign_in_user

		before { question }

		it 'deletes the question from the database' do 
			expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
		end
		
		it 'redirects to questions#index' do
			delete :destroy, id: question
			expect(response).to redirect_to questions_path
		end
	end
end



















