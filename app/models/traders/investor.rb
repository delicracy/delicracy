class Investor < Trader
  def excute(transaction)
    transaction.invest
  end

  def able_to_trade?(user, lane, lot)
    user.enough_coins?(@statement.expected_volume) and user.within_limit?(@statement.race.lane_ids) and not user.constraint_time?(lane.race.lane_ids)
  end

  def history_name
    'in_offered'
  end

  def history_type
    History::DEBIT
  end
end

