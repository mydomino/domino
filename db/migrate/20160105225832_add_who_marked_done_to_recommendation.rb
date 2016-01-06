class AddWhoMarkedDoneToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :updated_by, :integer
  end
end
