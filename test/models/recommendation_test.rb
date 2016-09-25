require "test_helper"

class RecommendationTest < ActiveSupport::TestCase

  should belong_to :dashboard
  should belong_to :recommendable
  #should belong_to :concierge
  should validate_presence_of :dashboard_id
  should validate_uniqueness_of(:recommendable_id).scoped_to([:dashboard_id, :recommendable_type])

  def setup
  	# using fixture data - refer to the fixture file name
    @recommendation = recommendations(:Recommendation_1)
  end


  def test_valid
    assert @recommendation.valid?
    
  end
end
