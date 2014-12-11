require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
	let(:question) { create(:question) }

	describe 'GET #index' do
		let(:questions) { create_list(:question, 2) }

		before { get :index }

		it 'populates an array of  all questions' do
			expect(assigns(:questions)).to match_array(questions)
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
		before { get :new }

		it 'it assigns new Question to @question' do
			expect(assigns[:question]).to be_a_new(Question)
		end

		it 'renders the :new template' do
			expect(response).to render_template :new
		end
	end

	describe 'GET #edit' do
		before { get :edit, id: question }

		it 'assigns requested question to @question' do
			expect(assigns(:question)).to eq question
		end

		it 'renders the :edit template' do
			expect(response).to render_template :edit
		end
	end
end
