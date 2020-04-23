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

  def check_user!
    unless session_valid? && user_logged_in?
      redirect_to login_path
    end
  end

  def session_valid?
    !current_session.expired?
  end

  def user_logged_in?
    current_user.present?
  end

  def current_user
    @current_user ||= current_session.try(:user)
  end

  def current_session
    begin
      @current_session ||= Session.find(session[:sesh_id]) if session[:sesh_id]
    rescue
      nil
    end
  end

  def invalidate_session
    @current_user = session[:user_id] = nil
    reset_session
  end
end
