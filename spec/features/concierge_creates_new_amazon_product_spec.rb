require 'rails_helper'


RSpec.feature "Concierge creates a new product", :type => :feature do
  let(:product_id) { 'B009GDHYPQ' }  #Nest Thermostat ID

  scenario "by inputting the item's Amazon ID" do

    visit new_amazon_product_path
    fill_in "Product ID", with: product_id
    click_on "Create"

    expect(page).to have_content(product_id)
  end
end