class History
  include Mongoid::Document
  include Mongoid::Timestamps
  extend SimplestStatus

  field :name, type: String
  field :balance, type: BigDecimal
  field :type, type: Integer, default: 0
  belongs_to :subject, polymorphic: true
  belongs_to :basis, polymorphic: true

  scope :recent, -> { order(updated_at: :desc) }

  simple_status :type, %i(none credit debit)

  def self.tab_contents(type)
    if valid_type?(type)
      self.send(type.to_sym)
    else
      self.none
    end
  end

  private

  def self.valid_type?(type)
    self.types.has_key? type.to_sym
  end
end
