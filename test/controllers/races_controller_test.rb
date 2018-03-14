require 'test_helper'

class RacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @race = create(:race, host: @user)
  end

  test "should get index" do
    get races_url
    assert_response :success
  end

  test "should redirect get new when not logged in" do
    get new_race_url
    assert_redirected_to login_url
  end

  test "should get new when logged in" do
    log_in_as @user
    get new_race_url
    assert_response :success
  end

  test "should redirect create race when not logged in" do
    assert_no_difference('Race.count') do
      post races_url, params: { race: { description: @race.description, title: @race.title } }
    end
    assert_redirected_to login_url
  end

  test "should create race when logged in" do
    log_in_as @user
    params = attributes_for(:race).merge({category_id: Category.first&.id || create(:category).id})
    assert_difference('Race.count') do
      post races_url, params: { race: params }
    end
    assert_redirected_to race_url(Race.first)
  end

  test "should show race" do
    log_in_as @user
    get race_url(@race)
    assert_response :success
  end

  test "should get edit" do
    log_in_as @user
    get edit_race_url(@race)
    assert_response :success
  end

  test "should update race" do
    log_in_as @user
    patch race_url(@race), params: { race: { description: @race.description, title: @race.title } }
    assert_redirected_to race_url(@race)
  end

  test "should destroy race" do
    log_in_as @user
    assert_difference('Race.count', -1) do
      delete race_url(@race)
    end

    assert_redirected_to races_url
  end
end
