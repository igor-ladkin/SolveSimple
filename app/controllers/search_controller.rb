class SearchController < ApplicationController
	skip_authorization_check

  def search
    @results = ThinkingSphinx.search params[:q], classes: filters
    put_questions_at_top
  end

  private

  def filters
  	search_in = []
  	search_in << Question if params[:search_questions] == '1'		
  	search_in << Answer if params[:search_answers] == '1'
  	search_in << Comment if params[:search_comments] == '1'
 		search_in.concat [Question, Answer, Comment] if search_in.empty?
 		search_in
  end

  def put_questions_at_top
  	temp = @results.select { |element| element.is_a? Question }
  	@results = temp + (@results - temp)
  end
end
