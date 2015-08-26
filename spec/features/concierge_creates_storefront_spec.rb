require 'rails_helper'

RSpec.feature "Concierge adds a new storefront", :type => :feature, focus: true do
  scenario "by selecting products from a dropdown list" do
    visit new_amazon_storefront_path

    expect(page).to have_css('select')
  end
end

