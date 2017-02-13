# == Schema Information
#
# Table name: organizations
#
#  id           :integer          not null, primary key
#  name         :string
#  email        :string
#  phone        :string
#  fax          :string
#  company_url  :string
#  sign_up_code :string
#  join_date    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  users_count  :integer          default(0)
#  email_domain :string
#


require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
