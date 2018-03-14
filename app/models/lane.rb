class Lane
  include Mongoid::Document
  include Mongoid::Timestamps
  include Calculator

  field :title, type: String
  field :description, type: String
  mount_uploader :picture, PictureUploader
  field :youtube_url, type: String
  field :is_winner, type: Boolean, default: false

  has_many :offers
  field :lot, type: BigDecimal
  field :price, type: BigDecimal
  field :volume, type: BigDecimal
  field :balance, type: BigDecimal, default: 0

  belongs_to :race, inverse_of: :lanes
  has_and_belongs_to_many :investors, class_name: 'User'
  embeds_many :price_trends

  validates :title, presence: true
  validates :youtube_url, youtube_url: true, allow_blank: true

  scope :winner, -> { find_by(is_winner: true) }
  scope :losers, -> { where(is_winner: false) }

  def expected_price(offer_lot)
    finished_price = (lot + offer_lot) / (total_lots + offer_lot) * 100
    (price + finished_price) / 2
  end

  def complete_trade(offer)
    # TODO
    race.complete_trade(offer)
    calculate_price
    calculate_volume
    price_trends.create(price: offer.price)
    save
  end

  def prepared?
    race.prepared?
  end

  def give(amount, of:, to: nil, basis:)
    case of
    when :coin
      self.balance += amount
      self.save
    when :lane
      self.lot += amount 
      self.save
    else
      false
    end
  end

  def take(amount, of:, to: nil, basis:)
    case of
    when :coin
      self.balance -= amount
      self.save
    when :lane
      self.lot -= amount
      self.save
    else
      false
    end
  end

  def enough_lots?(lot)
    self.lot >= lot
  end

  def youtube_id
    Youtube.build(youtube_url)&.id if youtube_url
  end

  def invested_lots
    total_lots - MY_APP[:initial_lot_per_lane]
  end

  def invested_volume
    invested_lots * price
  end

  def in_lot
    lot - MY_APP[:initial_lot_per_lane]
  end

  def in_volume
    in_lot * price
  end

  def data_points
    price_trends.order_by(created_at: :asc).map do |trend|
      { x: trend.created_at.to_datetime.strftime("%Q").to_i, y: (trend.price * 1000).to_i }
    end
  end

  private

  def total_lots
    race.total_lots
  end
end
