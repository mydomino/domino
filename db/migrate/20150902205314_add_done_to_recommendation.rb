class AddDoneToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :done, :boolean
  end
end
