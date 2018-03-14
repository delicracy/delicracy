require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transaction = build(:transaction)
  end

  test "should get index" do
    skip
    get transactions_url
    assert_response :success
  end

  test "should show transaction" do
    skip
    get transaction_url(@transaction)
    assert_response :success
  end
end
