class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |table|
      table.integer :recommendable_id
      table.string :recommendable_type
      table.integer :user_id
      table.integer :concierge_id
    end
  end
end
