class Admin::RacesController < Admin::BaseController
  def index
    @races = Race.page(params[:page]).per(10)
  end

  def show
  end
end
