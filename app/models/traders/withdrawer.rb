class Withdrawer < Trader
  def excute(transaction)
    transaction.withdraw
  end

  def able_to_trade?(user, lane, lot)
    user.enough_lots?(lot, of: lane) and lane.enough_lots?(lot) and not user.constraint_time?(lane.race.lane_ids)
  end

  def history_name
    'out_offered'
  end

  def history_type
    History::CREDIT
  end
end

