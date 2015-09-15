class ChangeAmazonStorefrontIdToDashboardIdInRecommendations < ActiveRecord::Migration
  def change
    rename_column :recommendations, :amazon_storefront_id, :dashboard_id
  end
end
