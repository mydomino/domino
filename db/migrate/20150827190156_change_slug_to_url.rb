class ChangeSlugToUrl < ActiveRecord::Migration
  def change
    rename_column :amazon_storefronts, :slug, :url
  end
end
