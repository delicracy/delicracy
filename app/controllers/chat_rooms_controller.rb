class ChatRoomsController < ApplicationController
  before_action :set_race, only: [:update]

  def join
    @race = Race.find(params[:race_id])
    @user = User.find(params[:user_id])
  rescue Mongoid::Errors::DocumentNotFound 
    render json: { result: false, message: 'Invalid Race or User.' }
  else
    if current_user? @user
      render 'join.json'
    else
      render json: { result: false, message: 'Invalid User.' }
    end
  end

  def user_info
    @race = Race.find(params[:race_id])
    @user = User.find(params[:user_id])
  rescue Mongoid::Errors::DocumentNotFound 
    render json: { result: false, message: 'Invalid Race or User.' }
  else
    render 'join.json'
  end

  # TODO
  def update
    @race = Race.find(params[:race_id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { result: false, message: 'Invalid Race.' } 
  else
    render json: { result: 'OK' }    
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_race
    @race = Race.find(params[:race_id])
  end
end
