# NOTE
class LaneTransaction < Transaction
  def trade
    source.take(amount, of: :lane, to: destination, basis: basis)
    destination.give(amount, of: :lane, to: source, basis: basis)
  end

  def invest
    source.give(amount, of: :lane, to: destination, basis: basis)
    destination.give(amount, of: :lane, basis: basis)
  end

  def withdraw
    source.take(amount, of: :lane, to: destination, basis: basis)
    destination.take(amount, of: :lane, basis: basis)
  end
end
