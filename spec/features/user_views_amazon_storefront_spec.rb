require 'rails_helper'

RSpec.feature "User views storefront", :type => :feature do
  scenario "to buy a product from Amazon" do
    visit show_amazon_storefront_path
  end
end