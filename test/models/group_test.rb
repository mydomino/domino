require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  test "can not be saved without a name" do

  	group = groups(:group_1)
  	group.name = nil

    assert_not group.valid?
    assert_not group.save

  end

  test "can be saved with a name" do
    
  	group = groups(:group_1)

    assert group.valid?
    assert group.save

  end

  test "A group can have many users" do

  	group = groups(:group_1)

  	user_1 = users(:User_1)
  	user_2 = users(:User_2)
  	user_3 = users(:User_3)
  	user_4 = users(:User_4)

  	group.users << user_1
  	group.users << user_2
  	group.users << user_3

  	group.save

  	assert_equal 3, group.users.size
  	assert group.users.include? user_3
  	assert_not group.users.include? user_4

  end

end
