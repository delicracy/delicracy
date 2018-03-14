class SessionsController < ApplicationController
  def new; end

  def create
    user = User.login_by_email.where(email: params[:session][:email].downcase).first

    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        redirect_back_or root_url
      else
        flash[:warning] = "Account not activated. Check your email for the activation link."
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def omniauth
    user = User.from_omniauth(request.env['omniauth.auth'])
    log_in user
    redirect_back_or root_url
  end
end
