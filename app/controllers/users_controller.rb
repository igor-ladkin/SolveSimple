class UsersController < ApplicationController
	before_action :set_user, only: [:finish_signup]

	def finish_signup
    if request.patch? && params[:user]
      if @user.update(user_params)
        sign_in(@user, :bypass => true)
        redirect_to root_path, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    accessible = [ :email ] 
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end