class Asset < Account
  field :amount, type: Integer, default: 0
  field :value, type: BigDecimal
  
  belongs_to :lane
  
  def race
    lane&.race
  end

  def self.total_volume
    sum { |asset| asset.amount * ( asset.lane&.price || 0 ) }
  end
end
