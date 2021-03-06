class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!



  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :agree) }
  end

  def admin_only
    unless current_user.admin?
      redirect_to :root, :alert => "Access denied."
    end
  end

  def provider_only
    unless current_user.service_provider? || current_user.admin?
      redirect_to :root, :alert => "Access denied."
    end
  end

  def recruiter_only
    unless current_user.recruiter? || current_user.admin?
      redirect_to :root, :alert => "Access denied."
    end
  end

end
