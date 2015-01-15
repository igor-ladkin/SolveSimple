class CommentsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_commentable
	before_action :load_comment, only: [:edit, :update, :destroy]
	before_action :verificate_authorship, only: [:edit, :update, :destroy]

	def new
		@comment = Comment.new

		respond_to do |format|
			format.html { redirect_to @commentable }
			format.js
		end
	end

	def create
		@comment = @commentable.comments.new(comment_params.merge(user: current_user))
		
		respond_to do |format|
			if @comment.save
				format.js
			else
				format.js { render :new }
			end
		end
	end

	def edit
		@commentable = @comment.commentable

		respond_to do |format|
			format.html { redirect_to @commentable }
			format.js
		end
	end

	def update
		@commentable = @comment.commentable

		respond_to do |format|
			if @comment.update(comment_params)
				format.js
			else
				format.js { render :edit }
			end
		end
	end

	def destroy
		@commentable = @comment.commentable

		@comment.destroy
		redirect_to @commentable
	end

	protected

	def verificate_authorship
		@record = @comment
		super
	end

	private

	def load_comment
		@comment = Comment.find(params[:id])
	end

	def comment_params
		params.require(:comment).permit(:body)
	end

	def set_commentable
		@commentable = case
									 when params[:question_id].present?
									   Question.find(params[:question_id])
									 when params[:answer_id].present?
									 	 Answer.find(params[:answer_id])
									 end
	end
end
