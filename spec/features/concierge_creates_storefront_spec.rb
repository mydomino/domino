require 'rails_helper'

RSpec.feature "Concierge adds a new storefront", :type => :feature, focus: true do
  scenario "by selecting products from a dropdown list" do
    amazon_product = FactoryGirl.create(:amazon_product)

    visit new_amazon_storefront_path

    expect(page).to have_css('input[type="checkbox"]')
  end
end

