class AddXmlAndPriceToAmazonProduct < ActiveRecord::Migration
  def change
    add_column :amazon_products, :price, :string
    add_column :amazon_products, :xml, :string
  end
end
