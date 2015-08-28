require 'rails_helper'

RSpec.feature "User views storefront", :type => :feature do

  let(:product) { FactoryGirl.create(:amazon_product) }

  scenario "to buy a product from Amazon" do
    product
    create_storefront
    storefront = AmazonStorefront.first
    
    visit amazon_storefront_path storefront

    expect(page).to have_content storefront.lead_name
    expect(page).to have_css('.amazon_product', text: product.name)
  end

  def create_storefront
    visit new_amazon_storefront_path
    fill_in "Lead's Name", with: Faker::Name.name
    check(product.name)
    click_on "Create"
  end
end