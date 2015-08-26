class CreateAmazonStorefront < ActiveRecord::Migration
  def change
    create_table :amazon_storefronts do |t|
      t.string :lead_name
      t.text :recommendation_explanation
      t.integer :concierge_id
      t.string :slug

      t.timestamps null: false
    end
  end
end
