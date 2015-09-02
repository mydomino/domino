require 'rails_helper'

RSpec.feature "User views storefront", :type => :feature, focus: true do

  let!(:product) { FactoryGirl.create(:amazon_product) }

  scenario "to buy a product from Amazon" do
    create_storefront
    storefront = AmazonStorefront.first
    
    visit amazon_storefront_path storefront

    click_on("I've bought this")
    expect(page).to have_css('.purchased', text: product.name)
  end

  def create_storefront
    concierge = FactoryGirl.create(:concierge)
    login_as(concierge, :scope => :concierge)
    visit new_amazon_storefront_path
    fill_in "Lead's Name", with: Faker::Name.name
    check(product.name)
    click_on "Create"
  end
end