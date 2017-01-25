# == Schema Information
#
# Table name: interests
#
#  id          :integer          not null, primary key
#  profile_id  :integer
#  offering_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_interests_on_offering_id  (offering_id)
#  index_interests_on_profile_id   (profile_id)
#
# Foreign Keys
#
#  fk_rails_d8d416875c  (offering_id => offerings.id)
#  fk_rails_e224210bc5  (profile_id => profiles.id)
#

require "test_helper"

class InterestTest < ActiveSupport::TestCase
  def interest
    @interest ||= Interest.new
  end

  def test_valid
    assert interest.valid?
  end
end
