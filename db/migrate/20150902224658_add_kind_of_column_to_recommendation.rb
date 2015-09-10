class AddKindOfColumnToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :recommendation_type, :string
  end
end
