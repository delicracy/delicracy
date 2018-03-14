module ChatsHelper
  def join_chat_url(race, user)
    "#{URI.join(MY_APP[:chat_domain], 'chatting')}/#{race.id}?join=#{current_user.id}#go_recent"
  end
end
