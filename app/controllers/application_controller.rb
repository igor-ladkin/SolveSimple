class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?

	rescue_from CanCan::AccessDenied do |e|
		redirect_to root_url, alert: e.message
	end

	check_authorization :unless => :devise_controller?

  protected 

  def verificate_authorship
		if current_user != @record.user
			redirect_to @record, :flash => { alert: 'Access denied.' }
		end
	end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password,  :password_confirmation, profile_attributes: [:first_name, :last_name, :nick_name]) }
  end
end
