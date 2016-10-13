require 'test_helper'
 
class ProfileTest < ActiveSupport::TestCase
  
  test "should save Profile with valid attributes" do
    profile = Profile.new(first_name: 'Foo', last_name: 'Bar', email: 'foo@bar.com')
    assert profile.save
  end

  test "should not save Profile without valid attributes" do
    profile = Profile.new
    assert_not profile.save
  end

  test "should not save Profile without first_name" do
    profile = Profile.new(last_name: 'Bar', email: 'foo@bar.com')
    assert_not profile.save
  end

  test "should not save Profile without last_name" do
    profile = Profile.new(first_name: 'Foo', email: 'foo@bar.com')
    assert_not profile.save
  end

  test "should not save Profile without email" do
    profile = Profile.new(first_name: 'Foo', last_name: 'Bar')
    assert_not profile.save
  end

  test "should downcase emails after save" do
    email = 'FOO@BAR.COM'
    profile = Profile.new(first_name: 'Foo', last_name: 'Bar', email: email)
    profile.save
    assert email.downcase == profile.email
  end
  
end