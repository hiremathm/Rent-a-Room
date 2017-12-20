class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


rescue_from CanCan::AccessDenied  do
  redirect_to root_path, notice: "You are not authorized to access this page."
end

  rescue_from SocketError  do
  	redirect_to root_path, notice: "Make sure You are not connected to internet"
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:mobile, :email, :username, :first_name, :last_name, :role_id])
  end
    
end
