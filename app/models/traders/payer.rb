class Payer < Trader
  def execute(transaction)
    transaction.pay
  end

  def history_name
    'payoff'
  end
end

