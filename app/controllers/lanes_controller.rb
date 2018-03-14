class LanesController < ApplicationController
  before_action :set_race
  before_action :set_lane, only: [:show, :edit, :update, :destroy]
  before_action :host_user, only: [:edit, :update, :destroy]

  def index
    @lanes = @race.lanes.all
  end

  def show
    @offer = Offer.new
  end

  def new
    @lane = @race.lanes.new
  end

  def edit
  end

  def create
    @lane = @race.lanes.new(lane_params)

    respond_to do |format|
      if @lane.save
        format.html { redirect_to @race, notice: 'Lane was successfully created.' }
        format.json { render :show, status: :created, location: @lane }
      else
        format.html { render :new }
        format.json { render json: @lane.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @lane.update(lane_params)
        format.html { redirect_to @race, notice: 'Lane was successfully updated.' }
        format.json { render :show, status: :ok, location: @lane }
      else
        format.html { render :edit }
        format.json { render json: @lane.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lane.destroy
    respond_to do |format|
      format.html { redirect_to @race, notice: 'Lane was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_race
    @race = Race.find(params[:race_id])
  end

  def set_lane
    @lane = @race.lanes.find(params[:lane_id])
  end

  def lane_params
    params.require(:lane).permit(:title, :description, :picture, :picture_cache, :youtube_url)
  end

  def host_user
    return if admin?

    unless @lane.race.host == current_user
      flash[:danger] = "You're not the host."
      redirect_to race_path(@lane.race)
    end
  end
end
