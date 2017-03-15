class AddTotalFatRewardPointsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_fat_reward_points, :integer, default: 0
  end
end
