class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update, :import, :account]

  def new
    @user = User.new
  end

  def show
    @title_bar = @user.name
    render layout: 'detail'
  end

  def create
    @user = User.new(user_params)
    @user.activated = true
    if @user.save
      # @user.send_activation_email
      # flash[:info] = "Please check your email to activate your account."
      flash[:info] = "Welcome to Delicracy."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def account
    @user = current_user
    @histories = @user.histories

    @title_bar = 'my account'
    render layout: 'detail'
  end

  def import
    @title_bar = 'Import BosCoin'
    render layout: 'detail'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :avatar_cache, :remove_avatar, :description)
  end

  def set_user
    @user = User.find(params[:user_id] || params[:id])
  end

  # match user and logged in user
  def correct_user
    @user = User.find(params[:user_id] || params[:id])
    redirect_to root_url unless current_user?(@user)
  end
end
