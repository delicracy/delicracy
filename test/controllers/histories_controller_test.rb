require 'test_helper'

class HistoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = create(:user)
    get user_histories_url(user)
    assert_response :success
  end

end
