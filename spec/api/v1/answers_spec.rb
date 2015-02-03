require 'rails_helper'

RSpec.describe 'Answers API' do
	let!(:question) { create(:question) }

	describe 'GET /index' do
		it_behaves_like 'API authenticable'

		context 'authorized' do
			let(:access_token) { create(:access_token) }
			let!(:answers) { create_list(:answer, 3, question: question) }

			before { get "/api/v1/questions/#{question.id}/answers", access_token: access_token.token, format: :json }

			it 'returns 200 status code' do
				expect(response).to be_success
			end

			it 'returns list of answers for exact question' do
				expect(response.body).to have_json_size(3).at_path('answers/')
			end

			%w(id body created_at updated_at).each do |attr|
				it "returns answer object with #{attr}" do
					expect(response.body).to be_json_eql(answers.first.send(attr).to_json).at_path("answers/0/#{attr}")
				end
			end
		end

		def do_request(options = {})
			get "/api/v1/questions/#{question.id}/answers",  { format: :json }.merge(options)
		end
	end

	describe 'GET /answers/:id' do
		let!(:answer) { create(:answer, question: question) }

		it_behaves_like 'API authenticable'

		context 'authorized' do
			let(:access_token) { create(:access_token) }
			let!(:comment) { create(:comment, commentable: answer) }
			let!(:attachment) { create(:attachment, attachmentable: answer) }

			before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", access_token: access_token.token, format: :json }

			it 'returns 200 status code' do
				expect(response).to be_success
			end

			%w(id body created_at updated_at).each do |attr|
				it "returns answer object with #{attr}" do
					expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answer/#{attr}")
				end
			end

			context 'comments' do
				it 'includes comments to answer' do
					expect(response.body).to have_json_size(1).at_path('answer/comments')
				end

				%w(id body created_at updated_at).each do |attr|
					it "returns comment object with #{attr}" do
						expect(response.body).to be_json_eql(comment.send(attr).to_json).at_path("answer/comments/0/#{attr}")
					end
				end
			end

			context 'attachments' do
				it 'includes attachments to answer' do
					expect(response.body).to have_json_size(1).at_path('answer/attachments')
				end

				it 'returns attachment object with url' do
					expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/file/url")
				end
			end
		end

		def do_request(options = {})
			get "/api/v1/questions/#{question.id}/answers/#{answer.id}",  { format: :json }.merge(options)
		end
	end

	describe 'POST /answers' do
		it_behaves_like 'API authenticable'

		context 'authorized' do
			let(:access_token) { create(:access_token) }
			let!(:answer) { attributes_for(:answer) }
			let(:invalid_answer) { attributes_for(:invalid_answer) }

			context 'with valid attributes' do
				it 'returns 200 status code' do
					post "/api/v1/questions/#{question.id}/answers", question: question, answer: attributes_for(:answer), user: access_token.resource_owner_id, access_token: access_token.token, format: :json 
					expect(response).to be_success
				end

				it 'saves an answer in the database' do
					expect {
						post "/api/v1/questions/#{question.id}/answers", question: question, answer: answer, user: access_token.resource_owner_id, access_token: access_token.token, format: :json 
					}.to change(Answer, :count).by(1)
				end

				it 'returns answer object with body' do
					post "/api/v1/questions/#{question.id}/answers", question: question, answer: answer, user: access_token.resource_owner_id, access_token: access_token.token, format: :json 
					expect(response.body).to be_json_eql(answer[:body].to_json).at_path('answer/body')
				end
			end

			context 'with invalid attributes' do
			end
		end

		def do_request(options = {})
			post "/api/v1/questions/#{question.id}/answers",  { question: question, answer: attributes_for(:answer), format: :json }.merge(options)
		end
	end
end