require 'rails_helper'

RSpec.feature "Concierge adds a new storefront", :type => :feature, focus: true do
  let(:full_name) { Faker::Name.name }
  let!(:concierge) { FactoryGirl.create(:concierge) }
  scenario "by selecting products from a dropdown list" do
    amazon_product = FactoryGirl.create(:amazon_product)

    visit new_amazon_storefront_path
    fill_in "Lead's Name", with: Faker::Name.name
    select(concierge.name, :from => 'Concierge')
    check(amazon_product.name)
    click_on "Create"
  end
end

