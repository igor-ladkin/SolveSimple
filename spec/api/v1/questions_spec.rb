require 'rails_helper'

RSpec.describe 'Questions API' do
	describe 'GET /index' do
		let(:api_path) { '/api/v1/questions' }

		it_behaves_like 'API authenticable'

		context 'authorized' do
			let(:access_token) { create(:access_token) }
			let!(:questions) { create_list(:question, 2) }
			let(:question) { questions.last  }
			let!(:answer) { create(:answer, question: question) }

			before { get '/api/v1/questions', format: :json, access_token: access_token.token }

			it 'returns 200 status code' do
				expect(response).to be_success
			end

			it 'returns list of questions' do
				expect(response.body).to have_json_size(2).at_path('questions')
			end

			%w(id title body created_at updated_at).each do |attr|
				it "returns question object with #{attr}" do
					expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("questions/1/#{attr}")
				end
			end

			it 'returns question object with short title' do
				expect(response.body).to be_json_eql(question.title.truncate(20).to_json).at_path("questions/1/short_title")
			end
		end

		def do_request(options = {})
			get '/api/v1/questions',  { format: :json }.merge(options)
		end
	end

	describe 'GET /question/:id' do
		let!(:question) { create(:question) }

		it_behaves_like 'API authenticable'

		context 'authorized' do
			let(:access_token) { create(:access_token) }
			let!(:comment) { create(:comment, commentable: question) }
			let!(:answer) { create(:answer, question: question) }
			let!(:attachment) { create(:attachment, attachmentable: question) }

			before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

			it 'returns 200 status code' do
				expect(response).to be_success
			end

			%w(id title body created_at updated_at).each do |attr|
				it "returns question object with #{attr}" do
					expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")
				end
			end

			context 'comments' do
				it 'it includes comments to questions' do
					expect(response.body).to have_json_size(1).at_path('question/comments')
				end

				%w(id body created_at updated_at).each do |attr|
					it "returns comment object with #{attr}" do
						expect(response.body).to be_json_eql(comment.send(attr).to_json).at_path("question/comments/0/#{attr}")
					end
				end
			end

			context 'attachments' do
				it 'it includes attachments to questions' do
					expect(response.body).to have_json_size(1).at_path('question/attachments')
				end

				it 'returns attachment object with url' do
					expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/file/url")
				end
			end
		end

		def do_request(options = {})
			get "/api/v1/questions/#{question.id}",  { format: :json }.merge(options)
		end
	end

	describe 'POST /questions' do
		it_behaves_like 'API authenticable'

		context 'authorized' do
			let(:access_token) { create(:access_token) }
			let!(:question) { attributes_for(:question) }
			let(:invalid_question) { create(:invalid_question) }

			context 'with valid attributes' do
				it 'returns 200 status code' do
					post '/api/v1/questions/', question: attributes_for(:question), user: access_token.resource_owner_id, format: :json, access_token: access_token.token
					expect(response).to be_success
				end

				it 'saves a question in the database' do
          expect {
         		post '/api/v1/questions/', question: attributes_for(:question), user: access_token.resource_owner_id, format: :json, access_token: access_token.token
         	}.to change(Question, :count).by(1)
        end

        %w(title body).each do |attr|
					it "returns question object with #{attr}" do
						post '/api/v1/questions/', question: question, user: access_token.resource_owner_id, format: :json, access_token: access_token.token
						expect(response.body).to be_json_eql(question[attr.to_sym].to_json).at_path("question/#{attr}")
					end
				end
			end

			context 'with invalid attributes' do
				it 'returns 422 status code' do
					post '/api/v1/questions/', question: attributes_for(:invalid_question), user: access_token.resource_owner_id, format: :json, access_token: access_token.token
					expect(response.status).to eq 422
				end

				it 'does not save question in the database' do
         expect {
         		post '/api/v1/questions/', question: attributes_for(:invalid_question), user: access_token.resource_owner_id, 
         		format: :json, access_token: access_token.token}.to_not change(Question, :count)
        end
			end
		end

		def do_request(options = {})
			post '/api/v1/questions',  { question: attributes_for(:question), format: :json }.merge(options)
		end
	end
end