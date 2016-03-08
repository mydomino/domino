class RemoveCommentFromRecommendations < ActiveRecord::Migration
  def change
    remove_column :recommendations, :comment
  end
end
