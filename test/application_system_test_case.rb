require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :firefox, screen_size: [1400, 1400]

  def log_in_as(user, options = {})
    password = options.fetch(:password, 'password')

    visit login_url
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Sign in'
  end
end
