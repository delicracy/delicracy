class CoinTransaction < Transaction
  def trade
    source.take(amount, of: :coin)
    destination.give(amount, of: :coin)
  end

  def invest
    source.take(amount, of: :coin, basis: basis)
    charge_fee
  end

  def withdraw
    source.give(amount, of: :coin, basis: basis)
    charge_fee
  end

  def fee(amount)
    amount * MY_APP[:transaction_fee]
  end

  def pay
    source.give(amount, of: :coin, basis: basis)
  end

  private

  def charge_fee
    transaction = self.class.apply(source: source, destination: destination, amount: fee(amount), basis: self)
    transaction.source.take(transaction.amount, of: :coin, basis: basis)
  end
end
