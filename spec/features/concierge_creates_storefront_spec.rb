require 'rails_helper'

RSpec.feature "Concierge adds a new storefront", :type => :feature, focus: true do
  scenario "to buy a product from Amazon" do
    visit new_amazon_storefront_path
  end
end

