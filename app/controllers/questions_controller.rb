class QuestionsController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
	before_action :load_question, only: [:show, :edit, :update, :destroy]
	before_action :verificate_authorship, only: [:edit, :update, :destroy]

	def index
		@questions = Question.includes(:tags).order(created_at: :desc)
	end

	def show
	end

	def new
		@question = Question.new

		respond_to do |format|
			format.html { redirect_to root_path }
			format.js
		end
	end

	def edit
		respond_to do |format|
			format.html { redirect_to @question }
			format.js
		end
	end

	def create
		@question = current_user.questions.new(question_params)

		respond_to do |format|
			if @question.save
				flash[:notice] = 'Your question was successfully created.'
				format.js do
					@questions = Question.order(created_at: :desc)
					#PrivatePub.publish_to '/questions', questions: Question.order(created_at: :desc).to_json
				end
			else
				format.js { render :new }
			end
		end
	end

	def update
		respond_to do |format|
			if @question.update(question_params)
				format.js
			else
				format.js { render :edit }
			end
		end
	end

	def destroy
		@question.destroy
		redirect_to questions_path
	end

	protected

	def verificate_authorship
		@record = @question
		super
	end

	private

	def load_question
		@question = Question.find(params[:id])
	end

	def question_params
		params.require(:question).permit(:title, :body, :tag_names, attachments_attributes: [:id, :file, :_destroy, :file_cache])
	end
end
