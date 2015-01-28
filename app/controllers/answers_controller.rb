class AnswersController < ApplicationController
	before_action :authenticate_user!
	before_action :get_question, only: [:new, :create]
	before_action :load_answer, only: [:edit, :update, :destroy]

	authorize_resource

	def new
		@answer = @question.answers.build

		respond_to do |format|
			format.html { redirect_to @question }
			format.js
		end
	end

	def edit
		respond_to do |format|
			format.html { redirect_to @answer.question }
			format.js
		end
	end

	def create
		@answer = @question.answers.build(answer_params.merge(user: current_user))

		respond_to do |format|
			if @answer.save
				format.js
			else
				format.js { render :new }
			end
		end
	end

	def update
		@question = @answer.question

		respond_to do |format|
			if @answer.update(answer_params)
				format.js
			else
				@question = nil
				format.js { render :edit }
			end
		end
	end

	def destroy
		@answer.destroy
		redirect_to @answer.question
	end

	private

	def get_question
		@question = Question.find(params[:question_id])
	end

	def load_answer
		@answer = Answer.find(params[:id])
	end

	def answer_params
		params.require(:answer).permit(:body, attachments_attributes: [:file])
	end
end
