require 'net/http'

module ChatRoom

  class Open
    attr_reader :params, :response, :uri

    Param = Struct.new(:ChatOpenReqID, :ChatOpenReqName, :ChatOpenDate, :ChatTitle, :race_id, :maxPeople)

    def initialize(user_id:, user_name:, race_title:, race_id:, max_people: 1000)
      @uri = URI.join(MY_APP[:chat_domain], '/chatting/', 'makereq')
      @params = Param.new.tap do |e|
        e.ChatOpenReqID = user_id.to_s
        e.ChatOpenReqName = user_name
        e.ChatOpenDate = Time.now.strftime("%Y%m%d%H%M")
        e.ChatTitle = race_title
        e.race_id = race_id.to_s
        e.maxPeople = max_people
      end
    end

    def call
      @response = Net::HTTP.post(uri, params.to_h.to_json, "Content-Type" => "application/json")
    end

    def expected_response
      {
        result: 'OK',
        race_id: params.ChatTitle,
        JoinPeople: 0,
        ChatRoomStat: 'Ready'
      }
    end
  end

  # TODO: not used
  class Join
    attr_reader :params

    def initialize(race_id:, user_id:)
      @params = OpenStruct.new(race_id: race_id, user_id: user_id)
      @race_id = race_id
      @user_id = user_id
    end

    def call
      URI.encode_www_form(join: 1234)
      URI.join("http://chat.delicracy.com/chatting/", "feajidjfijef", "?foo=bar")
    end
  end

  # HACK: need refactoring
  class Info
    attr_reader :params

    def initialize(race_id, method: 'chatinfo')
      @race_id = race_id
      @params = OpenStruct.new(race_id: race_id, method: method)
    end

    def call
      uri = URI("http://chat.delicracy.com/chatting/chatinfo")
      Net::HTTP.post(uri, params.to_h.to_json, "Content-Type" => "application/json")
    end
  end

  # HACK: need refactoring
  class UserInfo
    attr_reader :params

    def initialize(user_id, method: 'mainInfo')
      @params = OpenStruct.new(joinId: user_id, method: method)
    end

    def call
      uri = URI("http://chat.delicracy.com/chatting/chatinfo")
      Net::HTTP.post(uri, params.to_h.to_json, "Content-Type" => "application/json")
    end
  end
end
