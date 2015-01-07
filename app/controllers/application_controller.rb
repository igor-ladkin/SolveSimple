class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected 

  def verificate_authorship
		if current_user != @record.user
			redirect_to @record, :flash => { alert: 'Access denied.' }
		end
	end
end
