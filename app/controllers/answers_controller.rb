class AnswersController < ApplicationController
	before_action :get_question
	before_action :load_answer, only: [:edit, :update, :destroy]
	before_action :authenticate_user!

	def new
		@answer = Answer.new
	end

	def edit
	end

	def create
		@answer = @question.answers.new(answer_params.merge(user: current_user))

		if @answer.save
			redirect_to @question
		else
			render :new
		end
	end

	def update
		if @answer.update(answer_params)
			redirect_to @question
		else
			render :edit
		end
	end

	def destroy
		@answer.destroy
		redirect_to @question
	end

	private

	def get_question
		@question = Question.find(params[:question_id])
	end

	def load_answer
		@answer = @question.answers.find(params[:id])
	end

	def answer_params
		params.require(:answer).permit(:body)
	end
end