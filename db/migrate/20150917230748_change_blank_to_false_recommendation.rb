class ChangeBlankToFalseRecommendation < ActiveRecord::Migration
  def change

  end

  Recommendation.where(done: nil).each do |recommendation|
    recommendation.update_attribute(:done, false)
  end

end
