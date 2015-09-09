class AlterUrlColumnOnAmazonStorefront < ActiveRecord::Migration
  def change
    rename_column :amazon_storefronts, :url, :slug
  end
end
