require 'test_helper'

class Admin::RacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:admin)
    log_in_as @user
  end

  test "should get index" do
    get admin_races_url
    assert_response :success
  end

end
