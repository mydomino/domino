require 'rails_helper'


RSpec.feature "Concierge creates a new product", :type => :feature do
  let(:product_id) { 'B009GDHYPQ' }  #Nest Thermostat ID
  let(:concierge) { FactoryGirl.create(:concierge, name: "Dan Eaton") }

  scenario "by inputting the item's Amazon ID" do

    visit new_amazon_product_path
    fill_in "Product ID", with: product_id
    click_on "Create"

    expect(page).to have_content(AmazonProduct.first.name) #should be the Nest Name
  end
end