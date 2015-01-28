class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def self.providers_callack_for(provider)
		class_eval %Q{
			def #{provider}
				@user = User.find_for_oauth(env['omniauth.auth'])
		
				if @user.persisted?
					sign_in_and_redirect @user, event: :authentication
					set_flash_message(:notice, :success, kind: "#{provider}") if is_navigational_format?
				else
					session["devise.#{provider}_data"] = env['omniauth.auth']
					redirect_to new_user_registration_url
				end
			end
		}
	end

	[:facebook, :twitter].each do |provider|
		providers_callack_for provider
	end

	def after_sign_in_path_for(user)
		if user.email_verified?
			super user
		else
			finish_signup_path(user)
		end
	end
end