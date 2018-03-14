class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception

  private

  # make user log in
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please sign in."
      redirect_to login_url
    end
  end

  def composite_datetime(date, zone)
    offset = ActiveSupport::TimeZone.new(zone).formatted_offset
    datetime_str = "#{date[:date]} #{date[:hour]}:#{date[:minute]}:00#{offset}"
    DateTime.parse(datetime_str)
    # DateTime.new(date[:year].to_i, date[:month].to_i, date[:day].to_i, date[:hour].to_i, date[:minute].to_i, 0, offset)
  end
end
