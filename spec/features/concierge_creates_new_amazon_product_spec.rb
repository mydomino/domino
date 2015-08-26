require 'rails_helper'

RSpec.feature "Concierge creates a new product", :type => :feature, focus: true do
  let(:product_id) { 'B009GDHYPQ' }

  scenario "to buy a product from Amazon" do
    visit new_amazon_product_path
    fill_in "Product ID", with: product_id
    click_on "Create"

    expect(page).to have_content(product_id)
  end
end