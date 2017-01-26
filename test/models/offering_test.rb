# == Schema Information
#
# Table name: offerings
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


require "test_helper"

class OfferingTest < ActiveSupport::TestCase
  def offering
    @offering ||= Offering.new
  end

  def test_valid
    assert offering.valid?
  end
end
