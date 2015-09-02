require 'rails_helper'


RSpec.feature "Views all stores", :type => :feature do
  let!(:store) { FactoryGirl.create(:amazon_storefront) }
  let(:concierge) { FactoryGirl.create(:concierge) }
  scenario "through the web" do
    login_as(concierge, scope: :concierge)

    visit amazon_storefronts_path

    expect(page).to have_css('.store_list td', text: store.lead_name)
  end
end