class ChangeTypeofRecommendation < ActiveRecord::Migration
  def change
    rename_column :recommendations, :recommendation_type, :recommendable_type
  end
end
