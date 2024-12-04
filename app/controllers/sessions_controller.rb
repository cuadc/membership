class SessionsController < ApplicationController
  skip_before_action :check_user!

  def new
    invalidate_session
  end

  def create
    reset_session
    auth_hash = request.env["omniauth.auth"]
    user = User.from_omniauth(auth_hash)
    if user.nil?
      ApplicationMailer.new.mail(
        to: User.where(sysop: true, active: true).pluck(:email),
        subject: 'CUADC Membership Login Attempt Denied',
        body: <<~END
          Hello,

          This is an automated message from the CUADC Membership System. Please do
          not reply.

          An unsuccessful login attempt has just been made, the details of which
          are included below:
          #{auth_hash}

          Kind regards,

          The CUADC Membership System
        END
      ).deliver
      redirect_to login_url and return
    else
      sesh = Session.from_user_and_request(user, request)
      session[:sesh_id] = sesh.id
      redirect_to root_url
    end
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
