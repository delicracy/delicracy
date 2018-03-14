class Offer < Statement
  include Calculator
  extend SimplestStatus

  field :kind, type: String
  field :lot, type: BigDecimal
  field :price, type: BigDecimal
  field :volume, type: BigDecimal
  field :status, type: Integer, default: 0
  
  statuses :initial, :pending, :success, :failed

  attr_reader :trader
  belongs_to :user
  belongs_to :lane
  scope :successful, -> { order(created_at: :desc) }

  before_save :calculate_price, :calculate_volume

  validates :lot, presence: true, numericality: { greater_than: 0 }
  validates :kind, presence: true, inclusion: { in: %w(IN OUT) }

  def propose
    update(price: expected_price)
    self.pending
    arrange_trade
  end
  
  def complete_trade
    lane.complete_trade(self)
    create_history
    self.success
  end

  def race
    lane&.race
  end

  def expected_volume
    expected_price * lot
  end

  def able_to_trade?
    trader.able_to_trade?(user, lane, lot)
  end

  private

  def trader
    @trader ||= appoint_trader(kind)
  end

  def create_history
    user.reload if user.changed?
    History.create(subject: user,
                   name: trader.history_name,
                   balance: user.current_balance,
                   basis: self,
                   type: trader.history_type)
  end

  def appoint_trader(kind)
    case kind
    when "IN" then Investor.new(self)
    when "OUT" then Withdrawer.new(self)
    end
  end

  def arrange_trade
    prepare_transactions.each do |transaction|
      trader.excute(transaction)
    end
  end

  # FIXME: duplicate Calculator module
  def calculate_price
    self.price ||= expected_price
  end

  def expected_price
    lane.expected_price(lot)
  end

  def prepare_transactions
    [ LaneTransaction.apply(source: user, destination: lane, amount: lot, basis: self),
      CoinTransaction.apply(source: user, destination: lane, amount: expected_volume, basis: self),
    ]
  end
end
