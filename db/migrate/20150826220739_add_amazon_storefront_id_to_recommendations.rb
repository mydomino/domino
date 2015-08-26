class AddAmazonStorefrontIdToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :amazon_storefront_id, :integer
  end
end
