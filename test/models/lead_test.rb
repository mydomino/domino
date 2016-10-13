require "test_helper"

class LeadTest < ActiveSupport::TestCase
  def lead
    @lead ||= Lead.new
  end

  def test_valid
    assert lead.valid?
  end
end
