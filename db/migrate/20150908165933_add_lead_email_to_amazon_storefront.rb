class AddLeadEmailToAmazonStorefront < ActiveRecord::Migration
  def change
    add_column :amazon_storefronts, :lead_email, :string
  end
end
