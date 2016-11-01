require "test_helper"

class LegacyUserTest < ActiveSupport::TestCase
  def legacy_user
    @legacy_user ||= LegacyUser.new
  end

  def test_valid
    assert legacy_user.valid?
  end
end
