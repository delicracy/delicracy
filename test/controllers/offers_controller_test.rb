require 'test_helper'

class OffersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @race = create(:race_with_lanes)
    @lane = @race.lanes.first
    @user = create(:user)
    log_in_as @user
    @race.prepare!
  end

  test "should create offer" do
    post race_lane_offers_url(@race, @lane), params: { offer: { lot: 10 }, commit: 'IN' }
    assert flash[:success]
    assert_redirected_to race_url(@race)
  end

  test "should create transactions" do
    assert_difference 'Transaction.count', 3 do
      post race_lane_offers_url(@race, @lane), params: { offer: { lot: 10 }, commit: 'IN' }
    end

    travel_to Time.now + 2.minute do
      assert_difference 'Transaction.count', 3 do
        post race_lane_offers_url(@race, @lane), params: { offer: { lot: 10 }, commit: 'OUT' }
      end
    end
  end

  test "should different values in User and Lane when IN" do
  end
end
