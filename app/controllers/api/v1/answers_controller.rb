class Api::V1::AnswersController < Api::V1::BaseController
	authorize_resource

	before_action :load_question, only: [:index, :show, :create]

	def index
		@answers = @question.answers
		respond_with @answers, each_serializer: SimpleAnswerSerializer
	end

	def show
		@answer = @question.answers.find(params[:id])
		respond_with @answer, serializer: CompleteAnswerSerializer, root: :answer
	end

	def create
		@answer = @question.answers.create(answer_params.merge(user: current_resource_owner))
		respond_with @answer, serializer: CompleteAnswerSerializer, root: :answer
	end

	private 

	def load_question
		@question = Question.find(params[:question_id])
	end

	def answer_params
		params.require(:answer).permit(:body)
	end
end