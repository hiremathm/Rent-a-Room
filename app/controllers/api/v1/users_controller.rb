class Api::V1::UsersController < Api::V1::BaseController

	before_action :doorkeeper_authorize!, except: [:sign_in, :sign_up]

	#4dfdd703eef3464d21b40669a41be7f77dbd42942489caca6bde15ba3a39be4d
	#db363d6c264eadfcabfe436c10c5c9ae0ac07fe623f355e733b300a289c1e6aa

	def sign_up
		app_id = params['app_id']
		sec_id = params['app_secret']
		params[:user][:password] = "shiva123"
		params[:user][:password_confirmation] = "shiva123"
		app = authorize_application(app_id, sec_id)	
		if app == 404
			render json: {message: "Applicaiton Not found", ok: false}, status: 404
		else
			user = User.new(user_params)
			token = user.generate_token(app).token
			if user.save
				render json: {message: "User signed up successfully", user: user, ok: true, access_token: token}, status: 200
			else
				render json: {message: user.errors.full_messages.join(', '), ok: false}
			end
		end
	end

	def sign_in
		app_id = params['app_id']
		sec_id = params['app_secret']
		app = authorize_application(app_id, sec_id)	 
		if app == 404
			render json: {message: "Applicaiton Not found", ok: false}, status: 404
		else
			user = User.find_by(email: params["email"])
			token = user.generate_token(app).token
			if user.present?
				if user.valid_password?(params["password"])
					render json: {message: "User signed in successfully", user: user, ok: true, access_token: token}, status: 200
				else
					render json: {message: "Email or Password is not valid", ok: false}
				end
			else
				render json: {message: "Email or Password is not valid", ok: false}
			end
		end
	end

	def sign_out
		if current_token.try(:revoke)
			render json: {message: "User signed out successfully", ok: true}
		else
			render json: {message: "Invalid access token", ok: false}
		end
	end

	private 
	
	def user_params
  		params[:user].permit(:email, :password, :password_confirmation)
  	end
end