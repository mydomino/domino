require "test_helper"

class InterestTest < ActiveSupport::TestCase
  def interest
    @interest ||= Interest.new
  end

  def test_valid
    assert interest.valid?
  end
end
