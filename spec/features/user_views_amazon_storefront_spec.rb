require 'rails_helper'

RSpec.feature "User views storefront", :type => :feature do
  scenario "to buy a product from Amazon" do
    storefront = FactoryGirl.create(:amazon_storefront)
    
    visit amazon_storefront_path storefront

    expect(page).to have_content storefront.lead_name
  end
end