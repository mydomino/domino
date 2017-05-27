require 'test_helper'

class NotificationUserTest < ActiveSupport::TestCase
  
  test "not valid without a user" do
  	notification_user = notification_users(:notification_user_1)
  	notification_user.user = nil

    assert_not notification_user.valid?
  end

  test "It is valid after adding both a user and notification" do
  	
  	user = users(:User_1)
  	notification = notifications(:notification_1)

    user_2 = users(:User_2)
    notification_2 = notifications(:notification_2)

  	notification_user = NotificationUser.new(user: user, notification: notification, day: "Monday", send_hour: 15)

  	

    assert notification_user.valid?
    assert notification_user.save

    assert user.notifications.include? notification
    assert notification.users.include? user

    assert_not user.notifications.include? notification_2
    assert_not notification.users.include? user_2

  end

  test "can save a valid notification_user" do
  	
  	user = users(:User_1)
  	notification = notifications(:notification_2)

  	notification_user = NotificationUser.new(user: user, notification: notification, day: "Monday", send_hour: 15)
  	
    assert notification_user.save

  end


  test "it has association after adding notifications to a user" do
  	
  	user = users(:User_1)

  	notification_1 = notifications(:notification_1)
  	notification_2 = notifications(:notification_2)
  	notification_3 = notifications(:notification_3)
  	notification_4 = notifications(:notification_4)

  	user.notifications << notification_1
  	user.notifications << notification_2
  	user.notifications << notification_3

  	user.save

  	notification_users = NotificationUser.where(user: user)

    assert_equal 3, user.notifications.size
    assert_equal notification_users.size, user.notifications.size
  	assert user.notifications.include? notification_2
  	assert_not user.notifications.include? notification_4
  end
end
