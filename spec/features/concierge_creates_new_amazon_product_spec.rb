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

  scenario "by inputting the item's url", focus: true, js: true do 
    product_url = random_amazon_url
    visit new_amazon_product_path
    fill_in "Product URL", with: product_url
    click_on "Create"
  end
end

def random_amazon_url
  query = "Amazon #{Faker::Commerce.product_name}"
  google query
end

def google term
  visit "http://google.com/search?q=#{URI::encode(term)}"
  first('#ires h3 a').click
  return page.current_url
end