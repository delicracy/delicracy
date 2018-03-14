require 'test_helper'

class LaneTransactionTest < ActiveSupport::TestCase
  include ApplierInterface

  setup do
    @transaction = @object = LaneTransaction.new
  end
end

class CoinTransactionTest < ActiveSupport::TestCase
  include ApplierInterface

  setup do
    @transaction = @object = CoinTransaction.new
  end
end
