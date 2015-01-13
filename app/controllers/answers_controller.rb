class AnswersController < ApplicationController
	before_action :authenticate_user!
	before_action :get_question, only: [:new, :create]
	before_action :load_answer, only: [:edit, :update, :destroy]
	before_action :verificate_authorship, only: [:edit, :update, :destroy]

	def new
		@answer = Answer.new
		@answer.attachments.build

		respond_to do |format|
			format.html { redirect_to @question }
			format.js
		end
	end

	def edit
		@question = @answer.question

		respond_to do |format|
			format.html { redirect_to @question }
			format.js
		end
	end

	def create
		@answer = @question.answers.new(answer_params.merge(user: current_user))

		respond_to do |format|
			if @answer.save
				flash[:notice] = 'Your answer was successfully posted.'
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
				format.js { render :edit }
			end
		end
	end

	def destroy
		@question = @answer.question

		@answer.destroy
		redirect_to @question
	end

	protected

	def verificate_authorship
		@record = @answer
		super
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
