require 'rails_helper'


RSpec.feature "Concierge creates a new product", :type => :feature do
  scenario "by inputting the item's url" do 
    visit new_amazon_product_path
    fill_in "Product URL", with: 'http://www.amazon.com/gp/product/B00MMLTUG0/ref=s9_simh_gw_p422_d0_i3?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=desktop-3&pf_rd_r=1M5H0WVH8YS1CKTXPRMA&pf_rd_t=36701&pf_rd_p=2084660942&pf_rd_i=desktop'
    click_on "Create"
    fill_in "Name", with: "New Name"
    click_on "Save"

    expect(current_path).to eq(amazon_products_path)
    expect(page).to have_content("New Name")
  end
end