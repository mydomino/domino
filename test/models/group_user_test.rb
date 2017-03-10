require 'test_helper'

class GroupUserTest < ActiveSupport::TestCase

  test "not valid without a user" do
  	group_user = group_users(:group_user_one)
  	group_user.user = nil

    assert_not group_user.valid?
  end

  test "It is valid after adding both a user and group" do
  	
  	user = users(:User_1)
  	group = groups(:group_1)

    user_2 = users(:User_2)
    group_2 = groups(:group_2)

  	group_user = GroupUser.new(user: user, group: group, datetime_sign_in: Time.zone.now)

    assert group_user.valid?
    assert group_user.save

    assert user.groups.include? group
    assert group.users.include? user

    assert_not user.groups.include? group_2
    assert_not group.users.include? user_2

  end

  test "can save a valid group_user" do
  	
  	user = users(:User_1)
  	group = groups(:group_2)

  	group_user = GroupUser.new(user: user, group: group, datetime_sign_in: Time.zone.now)
  	
    assert group_user.save

  end


  test "it has correct association after adding groups to a user" do
  	
  	user = users(:User_1)

  	group_1 = groups(:group_1)
  	group_2 = groups(:group_2)
  	group_3 = groups(:group_3)
  	group_4 = groups(:group_4)

  	user.groups << group_1
  	user.groups << group_2
  	user.groups << group_3

  	user.save

  	group_users = GroupUser.where(user: user)

    assert_equal 3, user.groups.size
    assert_equal group_users.size, user.groups.size
  	assert user.groups.include? group_2
  	assert_not user.groups.include? group_4
  end

end
