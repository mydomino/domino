require "test_helper"

class DashboardTest < ActiveSupport::TestCase

  should have_many(:recommendations)
  should have_many(:products)
  should have_many(:tasks)
  should belong_to(:user)

  def dashboard
    @dashboard ||= Dashboard.new
  end

  def test_valid
    assert dashboard.valid?
  end
end
