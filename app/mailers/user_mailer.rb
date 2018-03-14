class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirm_registration.subject
  #
  def activate_user(user)
    @user = user
    mail to: user.email, subject: "Sign up to Delicracy"
  end

  def reset_password(user)
    @user = user
    mail to: user.email, subject: "Reset password"
  end
end
