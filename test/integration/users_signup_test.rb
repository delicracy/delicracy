require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar"
      } }
    end
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count' do
      post users_path, params: { user: { name: "Foobar",
                                         email: "foobar@example.com",
                                         password: "foobar",
                                         password_confirmation: "foobar"
      } }
    end
    follow_redirect!
    assert_template 'races/index'
  end
end
