# == Schema Information
#
# Table name: recommendations
#
#  id                 :integer          not null, primary key
#  concierge_id       :integer
#  dashboard_id       :integer
#  done               :boolean
#  recommendable_id   :integer
#  recommendable_type :string
#  created_at         :datetime
#  updated_at         :datetime
#  updated_by         :integer
#
# Indexes
#
#  index_recommendations_on_dashboard_id  (dashboard_id)
#  recommendable_index                    (recommendable_id,recommendable_type)
#

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
