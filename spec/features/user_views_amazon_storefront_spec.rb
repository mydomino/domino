require 'rails_helper'

RSpec.feature "User views storefront", :type => :feature do

  let!(:product) { FactoryGirl.create(:amazon_product) }
  let!(:concierge) { FactoryGirl.create(:concierge) }
  let!(:storefront) { FactoryGirl.create(:amazon_storefront, concierge: concierge) }

  scenario "to buy a product from Amazon" do
    storefront.amazon_products << product

    visit amazon_storefront_path storefront

    expect(page).to have_content storefront.lead_name
    expect(page).to have_css('.amazon_product', text: product.name)
  end

  scenario "to mark an item as purchased" do
    storefront.amazon_products << product  

    visit amazon_storefront_path storefront
    expect(page).not_to have_css('.amazon_product .done')

    click_on("I've bought this")
    expect(page).to have_css('.amazon_product .done')
  end

end