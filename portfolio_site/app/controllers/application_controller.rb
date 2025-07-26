class ApplicationController < ActionController::Base
  # Make these helper methods available in views
  helper_method :current_user, :logged_in?

  private

  # Returns the currently logged in user, if any
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # Predicate to check if a user is logged in
  def logged_in?
    current_user.present?
  end

  # Redirects to login page unless a user is logged in
  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Please log in to continue"
    end
  end
end