OpenChat = Struct.new(:ChatOpenReqID, :ChatOpenReqName, :ChatOpenDate, :ChatTitle, :race_id, :maxPeople)
params = OpenChat.new.tap do |e|
  e.ChatOpenReqID = "test123"
  e.ChatOpenReqName = "Test123"
  e.ChatOpenDate = "201712081111"
  e.ChatTitle = "ChatTest123"
  e.race_id = "race123"
  e.maxPeople = 1000
end

def open_chat(params)
  uri = URI.join(MY_APP[:chat_domain], 'chatting/makereq')
  header = { "Content-Type" => "application/json" }
  Net::HTTP.post(uri, params.to_h.to_json, header)
end
