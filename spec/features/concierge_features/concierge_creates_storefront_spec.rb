require 'rails_helper'

RSpec.feature "Concierge creates a new empty storefront", :type => :feature do
  let(:full_name) { Faker::Name.name }
  let!(:concierge) { FactoryGirl.create(:concierge) }
  scenario "by filling out the form" do
    amazon_product = FactoryGirl.create(:amazon_product)
    login_as(concierge, scope: :concierge)

    visit new_amazon_storefront_path
    fill_in "Lead's Name", with: Faker::Name.name
    fill_in "Lead's Email", with: Faker::Internet.email
    click_on "Create"
  end
end