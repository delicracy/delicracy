require 'test_helper'

class LaneTest < ActiveSupport::TestCase
  include GiverTakerInterface

  def setup
    @user = create(:user)
    @race = create(:race_with_lanes, host: @user)
    
    @lane = @object = @race.lanes.first
    # @race.lanes << 5.times.map { create(:lane) }
  end

  test "should be valid" do
    assert @lane.valid?
  end

  test "title should be present" do
    @lane.title = '     '
    assert_not @lane.valid?
  end

  test "price and volume should not set before prepared" do
    lane = @race.lanes.last

    @race.preparing
    assert_not lane.price
    assert_not lane.volume

    @race.prepare!
    lane.reload
    assert lane.price
    assert lane.volume
  end
end
