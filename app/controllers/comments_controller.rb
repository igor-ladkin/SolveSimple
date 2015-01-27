class CommentsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_commentable, only: [:new, :create]
	before_action :load_comment, only: [:edit, :update, :destroy]

	authorize_resource

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
		respond_to do |format|
			format.html { redirect_to @comment.commentable }
			format.js
		end
	end

	def update
		respond_to do |format|
			if @comment.update(comment_params)
				format.js
			else
				format.js { render :edit }
			end
		end
	end

	def destroy
		@comment.destroy
		@record = @comment.commentable

		@record = @record.question if @record.is_a? Answer
			
		redirect_to @record
	end

	private

	def load_comment
		@comment = Comment.find(params[:id])
	end

	def comment_params
		params.require(:comment).permit(:body)
	end

	def set_commentable
		resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
	end
end
