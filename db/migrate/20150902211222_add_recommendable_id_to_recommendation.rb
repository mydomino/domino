class AddRecommendableIdToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :recommendable_id, :integer
  end
end
