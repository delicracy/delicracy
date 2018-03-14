class OffersController < ApplicationController
  before_action :logged_in_user, :set_race, :set_lane

  def create
    @offer = @lane.offers.new(offer_params).tap do |offer|
      offer.kind = params[:commit]
      offer.user = current_user
    end
    # NOTE: do u need offer#valid?
    if @offer.valid? and @offer.able_to_trade?
      @offer.propose
    else
      @offer.failed
    end

    if not @offer.failed? and @offer.save
      @offer.complete_trade
      flash[:success] = "Your trade is completed."
    else
      flash[:danger] = "Failed to offer"
    end
    redirect_to @race
  end

  def show
  end

  def index
  end

  private

  def set_race
    @race = Race.find(params[:race_id])
  end

  def set_lane
    @lane = Lane.find(params[:lane_lane_id])
  end

  def offer_params
    params.require(:offer).permit(:lot)
  end
end
