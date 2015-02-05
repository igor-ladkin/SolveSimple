class ProfilesController < ApplicationController
	authorize_resource

	before_action :load_profile_with_email

	respond_to :html, :js

	def me
		respond_with @profile
	end

	private

	def load_profile_with_email
		@profile = Profile.includes(:user).find_by(user_id: current_user.id)
	end
end
