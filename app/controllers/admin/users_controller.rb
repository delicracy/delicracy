class Admin::UsersController < Admin::BaseController
  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
  end

  def edit
  end
end
