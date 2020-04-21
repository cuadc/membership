class ApplicationController < ActionController::Base

  before_action :check_user!
  helper_method :user_logged_in?

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    invalidate_session
    redirect_to login_path
  end

  private

  def user_logged_in?
    return true if current_user
  end

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue
      nil
    end
  end

  def check_user!
    unless user_logged_in?
      redirect_to login_path
    end
  end

  def invalidate_session
    @current_user = session[:user_id] = nil
    reset_session
  end
end
