class AddTypeToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :type, :string
    add_column :recommendations, :string, :string
  end
end
