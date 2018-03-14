require 'test_helper'
require 'minitest/mock'

class OfferTest < ActiveSupport::TestCase
  setup do
    @race = create(:race_with_lanes)
    @race.prepare!
    @lane = @race.lanes.first
    @offer = build(:offer, lane: @lane)
    @user = @offer.user
  end

  test "should be valid" do
    assert @offer.save
  end

  test "should be invalid" do
    @offer.kind = 'fijfiefojsij'
    assert_not @offer.save
  end

  test "should calculate price" do
    skip
    assert @offer.expected_price
    assert @offer.expected_volume
  end

  test "lot has a range of values" do
    @offer.lot = -1
    assert_not @offer.save
  end

  test "should propose successfully" do
    assert @offer.propose
  end

  test "requests applying transaction" do
    skip
    @applier = Minitest::Mock.new
    @applier.expect :apply, nil, [Lane.new, Lane.new, 100, @offer]
    
    @offer.propose2
    @applier.verify
  end

  test "should different values in User and Lane when IN" do
    # TODO
    @offer.save
    before_values = [@user.current_balance, @user.assets.find_or_initialize_by(lane: @lane).amount, @lane.price, @lane.lot]

    @offer.propose 
    @offer.complete_trade
    @user.reload

    after_values = [@user.current_balance, @user.assets.find_by(lane: @lane).amount, @lane.price, @lane.lot]

    before_values.each_with_index do |before_value, index|
      assert_not_equal before_value, after_values[index], "#{before_values}, #{after_values}"
    end
    assert_equal before_values[3] + @offer.lot, after_values[3]
  end
end
