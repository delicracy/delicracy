class VSOfficer < Officer
  def execute
    race.members.each do |member|
      payer = Payer.new(self)
      payer.execute(transaction(member))
    end
  end

  def volume_for_payoff(member)
    member.lots_for_each_lane.inject do |sum, e|
      lane = race.lanes.find(e[0])
      lots = e[1]
      sum + lane.price * lots
    end
  end
end
