class AddReasonRecommendedToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :comment, :text
  end
end
