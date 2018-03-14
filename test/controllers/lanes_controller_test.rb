require 'test_helper'

class LanesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lane = create(:lane)
    @race = @lane.race
    @user = @race.host
  end

  test "should get index" do
    get race_lanes_url(@race)
    assert_response :success
  end

  test "should get new" do
    get new_race_lane_url(@race)
    assert_response :success
  end

  test "should create lane" do
    assert_difference('Lane.count') do
      post race_lanes_url(@race), params: { lane: { description: @lane.description, title: @lane.title } }
    end

    assert_redirected_to race_url(@race)
  end

  test "should show lane" do
    get race_lane_url(@lane.race, @lane)
    assert_response :success
  end

  test "should get edit" do
    log_in_as @user
    get edit_race_lane_url(@lane.race, @lane)
    assert_response :success
  end

  test "should update lane" do
    patch race_lane_url(@lane.race, @lane), params: { lane: { description: @lane.description, title: @lane.title } }
    assert_redirected_to race_url(@lane.race)
  end

  test "should destroy lane" do
    log_in_as @user
    assert_difference('Lane.count', -1) do
      delete race_lane_url(@lane.race, @lane)
    end

    assert_redirected_to race_url(@lane.race)
  end
end
