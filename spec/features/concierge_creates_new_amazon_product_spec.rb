require 'rails_helper'

RSpec.feature "Concierge creates a new product", :type => :feature, focus: true do
  scenario "to buy a product from Amazon" do
    visit new_amazon_product_path
    fill_in "Product Id", with: 'B009GDHYPQ'
  end
end