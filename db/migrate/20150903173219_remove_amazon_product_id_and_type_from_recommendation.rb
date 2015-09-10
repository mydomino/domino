class RemoveAmazonProductIdAndTypeFromRecommendation < ActiveRecord::Migration
  def change
    remove_column :recommendations, :amazon_product_id
    remove_column :recommendations, :type
  end
end
