class WTAOfficer < Officer
  def execute
    race.members.each do |member|
      if lots_of_winner(member) > 0
        payer = Payer.new(self)
        payer.execute(transaction(member))
      end
    end
  end

  def volume_for_payoff(member)
    invested_share(member) * total_volume_of_losers 
  end

  private

  def invested_share(member)
    lots_of_winner(member) / total_lots_of_winner
  end

  def total_volume_of_losers 
    race.losers.inject do |sum, lane|
      sum + lane.invested_volume
    end
  end

  def total_lots_of_winner 
    race.winner.invested_lots.to_f
  end

  def lots_of_winner(member)
    member.lots_of_lane(race.winner)
  end
end

