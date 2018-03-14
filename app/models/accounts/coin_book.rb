class CoinBook < Account
  field :title, type: String
  field :volume, type: BigDecimal
  field :balance, type: BigDecimal

  after_create :create_history 

  def fill_columns
    update(title: basis.kind, volume: basis.volume)
  end

  private

  def create_history
    History.create(subject: user, name: 'signup_points',
                   balance: balance, basis: self, type: History::CREDIT)
  end
end
