require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:admin)
    log_in_as @user
  end
  
  test "should get index" do
    get admin_users_url
    assert_response :success
  end

end
