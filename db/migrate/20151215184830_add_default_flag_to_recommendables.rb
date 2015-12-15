class AddDefaultFlagToRecommendables < ActiveRecord::Migration
  def change
    add_column :tasks, :default, :boolean, default: false
    add_column :products, :default, :boolean, default: false
  end
end
