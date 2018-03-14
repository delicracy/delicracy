class Bill < Statement
  extend SimplestStatus

  field :volume, type: BigDecimal
  field :status, type: Integer, default: 0

  statuses :initial, :pending, :success, :failed
end
