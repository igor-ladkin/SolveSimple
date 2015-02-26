module VotableController
	def thumbs_up
		authorize! :thumbs_up, resource
		resource.thumbs_up(current_user)
		respond_to do |format|
			format.json { render json: resource.reload.to_json }
		end
	end

	def thumbs_down
		authorize! :thumbs_down, resource
		resource.thumbs_down(current_user)
		respond_to do |format|
			format.json { render json: resource.reload.to_json }
		end
	end
end