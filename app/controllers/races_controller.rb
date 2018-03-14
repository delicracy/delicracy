class RacesController < ApplicationController
  before_action :set_race, only: [:show, :edit, :update, :destroy, :data_series, :host_user, :chat_members]
  before_action :logged_in_user, except: [:index, :data_series]
  before_action :host_user, only: [:edit, :update, :destroy]

  def index
    category = Category.where(name: params[:category]).first || :all

    # check that user is tester or not
    if current_user&.is_tester
      @races = Race.by_category(category).page(params[:page])
    else
      @races = Race.by_category(category).not.tests.page(params[:page])
    end
    
    render layout: 'races/index'
  end

  def show
    @race.add_member current_user
    @race.save
    if @race.preparing?
      render :show
    else
      render :race_show
    end
  end

  def new
    @race = Race.new

    @title_bar = 'new race'
    render layout: 'detail'
  end

  def edit
  end

  def create
    @race = Race.new(race_params)
    @race.tap do |race|
      race.start_datetime = composite_datetime(params[:start], race_params[:time_zone])
      race.end_datetime = composite_datetime(params[:end], race_params[:time_zone])
      race.host = current_user
      race.add_member current_user
    end

    respond_to do |format|
      if @race.save
        format.html { redirect_to @race, flash: {success: 'Race was successfully created.'} }
        format.json { render :show, status: :created, location: @race }
      else
        format.html { render :new }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @race.tap do |race|
      race.start_datetime = composite_datetime(params[:start], race_params[:time_zone])
      race.end_datetime = composite_datetime(params[:end], race_params[:time_zone])
    end

    respond_to do |format|
      if @race.update(race_params)
        format.html { redirect_to @race, flash: {success: 'Race was successfully updated.'} }
        format.json { render :show, status: :ok, location: @race }
      else
        format.html { render :edit }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @race.destroy
    respond_to do |format|
      format.html do
        redirect_to races_url, flash: { success: 'Race was successfully destroyed.' }
      end
      format.json { head :no_content }
    end
  end

  def start
    @race = Race.find(params[:race_id])
    @race.prepare!
  rescue Race::NoLanesError
    flash[:danger] = "Failed to start. Race should have lanes."
  else
    open_chat.call
  ensure
    redirect_to @race
  end

  def data_series
    render json: @race.data_points
  end

  def chat_members
    
  end

  def assign_to_oracle
    return unless admin?

    @race = Race.find(params[:race_id])
    user = User.find(params[:user_id] || current_user.id)
    @race.tap do |race|
      race.oracle = user
      race.add_member user
      race.save
    end
  end

  private

  def set_race
    @race = Race.find(params[:id])
  end

  def race_params
    params.require(:race).permit(:title, :description, :rule, :time_zone, :start_datetime, :end_datetime, :picture, :picture_cache, :youtube_url, :category_id)
  end

  def open_chat
    ChatRoom::Open.new(
      user_id: current_user.id,
      user_name: current_user.name,
      race_title: @race.title,
      race_id: @race.id,
      max_people: 1000)
  end

  def host_user
    return if admin?
    
    unless @race.host? current_user
      flash[:danger] = "You're not the host."
      redirect_to race_path
    end
  end

end
