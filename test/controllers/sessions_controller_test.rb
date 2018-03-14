require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  test "should get login page" do
    get login_path
    assert_response :success
  end

  test "should login" do
    @user = create(:user)
    log_in_as @user
    assert_equal @user.id, session[:user_id]
  end

end
