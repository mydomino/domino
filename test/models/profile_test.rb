# == Schema Information
#
# Table name: profiles
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  first_name           :string
#  last_name            :string
#  email                :string
#  phone                :string
#  address_line_1       :string
#  city                 :string
#  state                :string
#  zip_code             :string
#  housing              :string
#  avg_electrical_bill  :integer          default(0)
#  onboard_complete     :boolean          default(FALSE)
#  onboard_step         :integer          default(1)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  dashboard_registered :boolean          default(FALSE)
#  campaign             :string
#  ip                   :string
#  referer              :string
#  browser              :string
#  partner_code_id      :integer
#
# Indexes
#
#  index_profiles_on_partner_code_id  (partner_code_id)
#  index_profiles_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_7c48a5d7d6  (partner_code_id => partner_codes.id)
#  fk_rails_e424190865  (user_id => users.id)
#


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
