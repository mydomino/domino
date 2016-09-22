require "test_helper"

class DashboardTest < ActiveSupport::TestCase
  def dashboard
    @dashboard ||= Dashboard.new
  end

  def test_valid
    assert dashboard.valid?
  end
end
