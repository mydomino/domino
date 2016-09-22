require "test_helper"

class RecommendationTest < ActiveSupport::TestCase
  def recommendation
    @recommendation ||= Recommendation.new
  end

  def test_valid
    assert recommendation.valid?
  end
end
