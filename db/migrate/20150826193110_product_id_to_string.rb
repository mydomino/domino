class ProductIdToString < ActiveRecord::Migration
  def change
    change_column :amazon_products, :product_id, :string
  end
end
