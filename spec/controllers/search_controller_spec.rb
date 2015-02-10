require 'rails_helper'

RSpec.describe SearchController, :type => :controller do
	let!(:question_with_phrase) { create(:question, body: 'Pizza, pasta, ravioli!') }
	let!(:question_without_phrase) { create(:question, body: 'Blue, yellow, white.') }
	let!(:answer_with_phrase) { create(:answer, body: 'It was a good pizza, buddy.') }
	let!(:answer_without_phrase) { create(:answer, body: "I don't know what am I doing here.") }
	let!(:comment_with_phrase) { create(:comment, body: 'I would like more pizza like that.') }
	let!(:comment_without_phrase) { create(:comment, body: "I'm good guys! But who cares, right?") }

	describe 'GET /search' do
		context 'default search in all classes' do
    	before { get :search, q: 'pizza' }

			it 'includes question_with_phrase to @results' do
				debugger
				expect(assigns[:results]).to include question_with_phrase
			end

			it 'includes answer_with_phrase to @results' do
				expect(assigns[:results]).to include answer_with_phrase
			end

			it 'includes comment_with_phrase to @results' do
				expect(assigns[:results]).to include comment_with_phrase
			end
		end
	end
end
