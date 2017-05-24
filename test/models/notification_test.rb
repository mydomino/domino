require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  
  test "can not be saved without a description" do

  	notification = notifications(:notification_1)
  	notification.description = nil

    assert_not notification.valid?
    assert_not notification.save

  end

  test "can be saved with a description and a name" do
    
  	notification = notifications(:notification_2)

    assert notification.valid?
    assert notification.save

  end

  test "A notification can have many users" do

  	notification = notifications(:notification_3)

  	user_1 = users(:User_1)
  	user_2 = users(:User_2)
  	user_3 = users(:User_3)
  	user_4 = users(:User_4)

  	notification.users << user_1
  	notification.users << user_2
  	notification.users << user_3

  	notification.save

  	assert_equal 3, notification.users.size
  	assert notification.users.include? user_3
  	assert_not notification.users.include? user_4

  end

end
