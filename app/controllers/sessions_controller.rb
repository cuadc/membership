class SessionsController < ApplicationController
  skip_before_action :check_user!

  def new; end

  def create
    reset_session
    auth_hash = request.env["omniauth.auth"]
    user = User.from_omniauth(auth_hash)
    redirect_to login_url and return if user.nil?
    sesh = Session.from_user_and_request(user, request)
    session[:sesh_id] = sesh.id
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
