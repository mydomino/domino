class AddNameToAmazonProduct < ActiveRecord::Migration
  def change
    add_column :amazon_products, :name, :string
  end
end
