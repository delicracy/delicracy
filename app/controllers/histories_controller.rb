class HistoriesController < ApplicationController
  before_action :set_user

  def index
    if params[:type] == :all
      @histories = @user.histories.recent
    else
      @histories = @user.histories.tab_contents(params[:type])
    end
    @type = params[:type]
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end
end
