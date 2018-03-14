module Calculator
  def calculate_price
    self.price = lot / total_lots * 100
    self
  end

  def calculate_price!
    calculate_price.save
  end

  def calculate_volume
    self.volume = price * lot
    self
  end

  def calculate_volume!
    calculate_volume.save
  end
end
