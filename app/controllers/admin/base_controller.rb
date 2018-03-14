class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :logged_in_user
  before_action :require_admin

  private

  def require_admin
    redirect_to root_path unless admin?
  end
end
