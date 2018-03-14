# User class to use services. profile information and authentication processing
class User
  attr_accessor :activation_token, :reset_token

  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  extend SimplestStatus

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :oraclable, type: Boolean, default: false
  field :is_admin, type: Boolean, default: false
  field :is_tester, type: Boolean, default: false
  field :description, type: String
  field :login_mode, type: Symbol, default: :email
  mount_uploader :avatar, AvatarUploader

  field :activation_digest, type: String
  field :activated, type: Boolean, default: false
  field :activated_at, type: DateTime
  field :activation_sent_at, type: DateTime
  field :reset_digest, type: String
  field :reset_sent_at, type: DateTime

  has_many :identities, dependent: :destroy
  has_many :offers
  has_one :coin_book
  has_many :assets
  has_many :histories, as: :subject

  scope :login_by_email, -> { where(login_mode: :email) }

  before_save { self.email = email.downcase }
  before_create :create_activation_digest
  after_create :give_signup_points

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 30 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false, if: proc { |user| user.login_mode == :email } }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :login_mode, presence: true, inclusion: { in: %i(email facebook kakao) }

  # Related with authentication.

  # return hashed value
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.from_omniauth(auth)
    Identity.where(auth.slice(:provider, :uid)).first_or_initialize.tap do |identity|
      identity.provider = auth.provider
      identity.uid = auth.uid
      identity.oauth_token = auth.credentials.token
      identity.oauth_expires_at = Time.at(auth.credentials.expires_at)
      unless identity.user
        if auth.provider == 'kakao'
          response = Net::HTTP.post(URI('https://kapi.kakao.com/v1/user/me'), nil, Authorization: "Bearer #{auth.credentials.token}")
          email = JSON.parse(response.body)['kaccount_email']
        else
          email = auth.info.email
        end
        identity.user = User.create!(
          name: auth.info.name,
          email: email,
          remote_avatar_url: auth.info.image,
          password: Faker::Internet.password,
          login_mode: auth[:provider])
      end
      identity.save!
    end.user
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.activate_user(self).deliver_now
    update_attribute(:activation_sent_at, Time.zone.now)
  end

  def activation_expired?
    activation_sent_at < 1.day.ago
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_send_at, Time.zone.now)
  end

  def send_reset_password_email
    UserMailer.reset_password(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Related with trades

  def give(amount, of:, to: nil, basis:)
    case of
    when :coin
      coin_book.balance += amount
      coin_book.save
    when :lane
      asset = assets.find_or_initialize_by(lane: to)
      asset.amount += amount
      asset.save
    else
      false
    end
  end

  def take(amount, of:, to: nil, basis:)
    case of
    when :coin
      coin_book.balance -= amount
      coin_book.save
    when :lane
      begin
        asset = assets.find_by(lane: to)
      rescue Mongoid::Errors::DocumentNotFound
        raise
      else
        asset.amount -= amount
        asset.save
      end
    else
      false
    end
  end

  def enough_coins?(amount)
    current_balance >= amount
  end

  def current_balance
    coin_book.reload.balance
  end

  def enough_lots?(lot, of:)
    begin
      asset = assets.find_by(lane: of)
    rescue Mongoid::Errors::DocumentNotFound
      false
    else
      asset.amount >= lot
    end
  end

  def within_limit?(ids)
    MY_APP[:investment_limit] >= lots_for_each_lane(ids).inject(0) { |sum, item| sum += item[1] }
  end

  def races
    set = Set.new
    assets.each { |asset| set << asset.lane&.race }
    set.delete(nil).to_a
  end

  def give_signup_points
    signup_points = MY_APP[:signup_points]
    create_coin_book(title: "Signup Points", volume: signup_points, balance: signup_points)
  end

  def lots_for_each_lane(lane_ids)
    assets.in(lane_id: lane_ids).pluck(:lane_id, :amount)
  end

  def lots_of_lane(lane)
    asset = assets.find_by(lane: lane)
  rescue Mongoid::Errors::DocumentNotFound
    0
  else
    asset.amount
  end

  def constraint_time?(lane_ids)
    last_time = offers.success.in(lane_id: lane_ids).last&.updated_at
    return false if last_time.nil?
    ( Time.now - last_time ) <= 1.minute
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
