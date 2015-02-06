class UsersController < ApplicationController
  skip_authorization_check

	before_action :set_user, only: [:finish_signup]

	def finish_signup
    if request.patch? && params[:user]
      if @user.update(user_params)
        @user.delay.send_reconfirmation_instructions
        sign_out @user
        redirect_to root_path, notice: 'Confirmation letter has been sent to you. Please follow insrtuctions to activate your account.'
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