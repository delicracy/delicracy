require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "acivate user" do
    user = create(:user)
    user.activation_token = User.new_token
    mail = UserMailer.activate_user(user)
    assert_equal "Sign up to Delicracy", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["no-reply@delicracy.com"], mail.from
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  test 'reset password' do
    user = create(:user)
    user.reset_token = User.new_token
    mail = UserMailer.reset_password(user)
    assert_equal "Reset password", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["no-reply@delicracy.com"], mail.from
    assert_match user.reset_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end
end
