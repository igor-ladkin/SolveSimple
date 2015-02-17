module VotableController
	def thumbs_up
		authorize! :thumbs_up, resource
		resource.thumbs_up(current_user)
		flash[:notice] = 'Your vote has been counted.'
		redirect_to :back
	end

	def thumbs_down
		authorize! :thumbs_down, resource
		resource.thumbs_down(current_user)
		flash[:notice] = 'Your vote has been counted.'
		redirect_to :back
	end
end