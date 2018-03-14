# Data for price charts. Record the price every time lane transactions occur.
class PriceTrend
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :price, type: BigDecimal
  embedded_in :lane
end
