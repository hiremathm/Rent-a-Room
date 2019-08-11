class Api::V1::BaseController < ApplicationController
	
	#Allow User to access application without authentication token
	protect_from_forgery with: :null_session
	
	#Exception Handling
	rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found
	rescue_from ::ActionController::RoutingError, with: :error_occurred
	rescue_from ::ActionController::UnknownFormat, with: :error_occurred
	# rescue_from ::ActionController::NoMethodError, with: :error_occurred
	private 
	def current_token
		token = Doorkeeper::AccessToken.find_by(token: params[:access_token])
		return token
	end

	def current_user
		User.find(current_token.resource_owner_id) if current_token.present?
	end

	def authorize_application(app_id, sec_id)
		app = Doorkeeper::Application.find_by(uid: app_id, secret: sec_id)
		if app.present?
			return app
		else
			return 404
		end
	end

	def record_not_found(exception)
		render json: {message: 	exception.message, ok: false}.to_json, status: 404 and return
	end

	def error_occurred(exception)
		render json: {message: exception.message, ok: false}.to_json, status: 500 and return
	end

	def user_not_authorized
    	render json: {message: 'Not Authorized', ok: false}.to_json, status: 403 and return
  	end
end