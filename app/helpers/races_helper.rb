module RacesHelper
  def chat_iframe(url)
    content_tag :iframe, id: 'chat_frame', name: 'chat_frame', data: { src: url }, scrolling: 'auto', frameborder: 0 do
      content_tag :p, "Your browser doesn't support iframes."
    end
  end

  def operator?(user: current_user)
    return unless current_user
    user.is_admin? or @race.host == user
  end

  def host?(user: current_user)
    return unless current_user
    user == self.host
  end

  def offset_datetime(datetime, zone)
    return DateTime.now if datetime.nil?
    return datetime if zone.nil?
    utc_offset = ActiveSupport::TimeZone.new(zone).formatted_offset
    datetime.localtime(utc_offset)
  end
end
