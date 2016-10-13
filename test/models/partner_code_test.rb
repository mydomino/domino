require "test_helper"

class PartnerCodeTest < ActiveSupport::TestCase
  def partner_code
    @partner_code ||= PartnerCode.new
  end

  def test_valid
    assert partner_code.valid?
  end
end
