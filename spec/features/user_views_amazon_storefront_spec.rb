require 'rails_helper'

RSpec.feature "User views storefront", :type => :feature do

  let!(:product) { FactoryGirl.create(:product) }
  let!(:concierge) { FactoryGirl.create(:concierge) }
  let!(:storefront) { FactoryGirl.create(:dashboard, concierge: concierge) }

  scenario "to buy a product from Amazon" do
    storefront.products << product

    visit dashboard_path storefront

    expect(page).to have_content storefront.lead_name
    expect(page).to have_css('.product', text: product.name)
  end

  scenario "to mark an item as purchased" do
    storefront.products << product  

    visit dashboard_path storefront
    expect(page).not_to have_css('.product .done')

    click_on("I've bought this")
    expect(page).to have_css('.product .done')
  end

end