class RenameAmazonStorefrontsToDashboards < ActiveRecord::Migration
  def change
    rename_table :amazon_storefronts, :dashboards
  end
end
