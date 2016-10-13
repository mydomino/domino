require "test_helper"

class OfferingTest < ActiveSupport::TestCase
  def offering
    @offering ||= Offering.new
  end

  def test_valid
    assert offering.valid?
  end
end
