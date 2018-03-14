class ResetPasswordController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.login_by_email.find_by(email: params[:reset_password][:email].downcase)
  rescue Mongoid::Errors::DocumentNotFound
    flash[:danger] = "Email address not found"
    render 'new'
  else
    @user.create_reset_digest
    @user.send_reset_password_email
    flash[:info] = "Email sent with password reset instructions"
    redirect_to root_url
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless @user&.activaed? and @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_reset_password_url
    end
  end
end
