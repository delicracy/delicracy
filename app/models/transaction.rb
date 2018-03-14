class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  extend SimplestStatus

  field :source_id, type: BSON::ObjectId # like User, Lane, System
  field :source_class, type: String
  field :destination_id, type: BSON::ObjectId # like User, Lane, System
  field :destination_class, type: String
  field :amount, type: BigDecimal, default: 0
  field :details, type: String
  field :status, type: Integer, default: 0
  belongs_to :basis, class_name: "Transaction"

  statuses :initial, :pending, :applied, :done, :canceling, :canceled

  def self.apply(source:, destination:, amount:, **others)
    create({ source_id: source.id, source_class: source.class.name, 
             destination_id: destination.id, destination_class: destination.class.name, 
             amount: amount }.merge(others))
  end

  def trade
    should_implement(__method__)
  end

  def invest
    should_implement(__method__)
  end

  def withdraw
    should_implement(__method__)
  end

  def source
    @source ||= source_class.constantize.find(source_id)
  end

  def destination
    @destination ||= destination_class.constantize.find(destination_id)
  end

  private

  def should_implement(name)
    raise NotImplementedError, "Inherited Transaction must be implemented ##{name}."
  end
end
