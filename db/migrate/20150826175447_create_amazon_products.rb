class CreateAmazonProducts < ActiveRecord::Migration
  def change
    create_table :amazon_products do |table|
      table.string :url
      table.integer :product_id
      table.string :description
      table.string :image_url

      table.timestamps null: false

    end
  end
end
