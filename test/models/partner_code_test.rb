# == Schema Information
#
# Table name: partner_codes
#
#  id           :integer          not null, primary key
#  code         :string
#  partner_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


require "test_helper"

class PartnerCodeTest < ActiveSupport::TestCase
  def partner_code
    @partner_code ||= PartnerCode.new
  end

  def test_valid
    assert partner_code.valid?
  end
end
