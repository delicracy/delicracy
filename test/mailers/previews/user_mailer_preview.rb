# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/activate_user
  def activate_user
    user = User.first
    user.activation_token = User.new_token
    UserMailer.activate_user(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/reset_password
  def reset_password
    user = User.first
    user.reset_token = User.new_token
    UserMailer.reset_password(user)
  end

end
