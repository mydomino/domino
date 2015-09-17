class AddTimeStampsToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :created_at, :datetime
    add_column :recommendations, :updated_at, :datetime
  end
end
