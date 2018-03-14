require 'test_helper'

class RaceStartTest < ActionDispatch::IntegrationTest
  setup do
    @user = build_stubbed(:user)
  end

  test 'prepare to race' do
    log_in_as @user
    post races_path, params: { title: 'start race' }
  end
end
