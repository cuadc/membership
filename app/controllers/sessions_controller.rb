class SessionsController < ApplicationController
  skip_before_action :check_user!

  def new; end

  def create
    reset_session
    auth_hash = request.env["omniauth.auth"]
    user = User.from_omniauth(auth_hash)
    redirect_to root_url and return if user.nil?
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    invalidate_session
    redirect_to login_path
  end

  def failure
    invalidate_session
    redirect_to login_path
  end
end
