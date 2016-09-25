require "test_helper"

class UserTest < ActiveSupport::TestCase

  # test associations
  should have_one :profile
  should have_one :dashboard

  def setup
  	# using fixture data
    @user = users(:User_1)
  end


  def test_valid
    assert @user.valid?
  end
end
