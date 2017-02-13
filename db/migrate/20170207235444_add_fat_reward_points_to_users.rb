class AddFatRewardPointsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fat_reward_points, :integer, default: 0
  end
end
