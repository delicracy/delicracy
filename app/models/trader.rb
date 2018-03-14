class Trader
  def initialize(statement)
    @statement = statement
  end

  def execute(transaction)
    raise NotImplementedError
  end

  def history_name
    raise NotImplementedError
  end
end
