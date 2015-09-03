class RemoveStringFromRecommendation < ActiveRecord::Migration
  def change
    remove_column :recommendations, :string
  end
end