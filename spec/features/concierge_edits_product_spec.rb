require 'rails_helper'

RSpec.feature "Concierge edits a product", :type => :feature do

  before(:each) { FactoryGirl.create(:amazon_product) }

  scenario "by going through the index page" do
    visit amazon_products_path
    click_on "Edit"


  end
end

