class Race
  include Mongoid::Document
  include Mongoid::Timestamps
  extend SimplestStatus

  before_save { self.title = title.strip }
  before_create { self.is_test = self.host.is_tester }

  field :title, type: String
  field :description, type: String
  field :rule, type: Integer, default: 0
  field :time_zone, type: String
  field :initial_lot, type: BigDecimal, default: MY_APP[:initial_lot_per_lane]
  field :status, type: Integer, default: 0
  field :start_datetime, type: DateTime, default: Time.now
  field :end_datetime, type: DateTime, default: Time.now
  field :youtube_url, type: String
  field :member_ids, type: Array, default: []
  belongs_to :host, class_name: 'User'
  belongs_to :oracle, class_name: 'User', optional: true
  has_many :lanes, dependent: :destroy, inverse_of: :race
  belongs_to :category
  mount_uploader :picture, PictureUploader
  field :hidden, type: Boolean, default: false
  field :is_test, type: Boolean, default: false

  simple_status :rule, %i(winner_takes_all vote_share)
  statuses :preparing, :ready, :racing, :pending, :closed
  validates :title, presence: true
  # validate :start_datetime_greater_than_now
  validate :end_datetime_should_be_greater_than_start_datetime
  validates :youtube_url, youtube_url: true, allow_blank: true

  default_scope -> { order_by(created_at: :desc) }
  scope :tests, -> { where(is_test: true) }
  scope :by_category, -> (category=:all) { where(category: category) unless category == :all }
  paginates_per 10

  # Check status
  def prepared?
    not preparing?
  end

  # Related with process

  def prepare!
    raise NoLanesError if lanes.length < 2
    initial_price = 1.0 / lanes.size * 100
    initial_volume = initial_lot * initial_price

    lanes.update_all(lot: initial_lot,
                     price: initial_price,
                     volume: initial_volume)
    lanes.each { |lane| lane.reload }
    self.ready
  end

  # Ranking of lanes

  def winner=(lane)
    lanes.update_all(is_winner: false)
    lane.update(is_winner: true)
  end

  def winner
    lanes.find_by(is_winner: true)
  end

  def losers
    lanes.where(is_winner: false)
  end

  def top_lane
    lanes.order(price: :desc).first
  end

  # Related with trade

  def total_lots
    lanes.sum(&:lot)
  end

  def complete_trade(offer)
    adjust_prices_of_lanes
  end

  def payoff
    case rule
    when WINNER_TAKES_ALL
      @payoffer = WTAOfficer.new(self)
    when VOTE_SHARE
      @payoffer = VSOfficer.new(self)
    end
    @payoffer.execute
  end

  # Related with operators

  def host?(user)
    host == user
  end

  def oracle?(user)
    oracle == user
  end

  # Related with members

  def members
    User.in(id: member_ids)
  end

  def add_member(user)
    member_ids << user.id unless member?(user)
  end

  def remove_member(user)
    member_ids.delete user.id
  end

  def member?(user)
    member_ids.include? user.id
  end

  # Related with views

  def info_for_user(user)
    info = []  
    info.tap do |arr|
      arr << :closed if closed?
      arr <<  user_info(user)
    end
  end

  def user_info(user)
    if host?(user)
      :host
    elsif oracle?(user)
      :oracle
    elsif member?(user)
      :member
    end
  end

  def youtube_id
    Youtube.build(youtube_url)&.id if youtube_url
  end

  def data_points
    lanes.map do |lane|
      { type: 'line', name: lane.title, showInLegend: true, xValueType: 'dateTime', dataPoints: lane.data_points }
    end
  end

  def dday
    if Time.now < start_datetime
      (Date.today...end_datetime.to_date).count
    else
      nil
    end
  end

  private

  def adjust_prices_of_lanes
    tmp_total_lots = total_lots
    lanes.each do |lane|
      lane.reload
      lane.price = lane.lot / tmp_total_lots * 100 # TODO: calculate_price with caution
      lane.save
    end
  end

  def end_datetime_should_be_greater_than_start_datetime
    if end_datetime < start_datetime
      errors.add(:end_datetime, "should be greater than start time." )
    end
  end

  def start_datetime_greater_than_now
    if not published? and start_datetime < Time.now
      errors.add(:start_datetime, "should be greater than now.")
    end
  end
end

class Race::NoLanesError < StandardError
  def initialize(msg="There is no lane.")
    super(msg)
  end
end
