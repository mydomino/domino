require 'rails_helper'


RSpec.feature "Views all of their stores", :type => :feature do
  let!(:store) { FactoryGirl.create(:amazon_storefront, concierge: concierge) }
  let(:concierge) { FactoryGirl.create(:concierge) }
  scenario "through the web" do
    login_as(concierge, scope: :concierge)

    visit amazon_storefronts_path

    expect(page).to have_css('.storefront', text: store.lead_name)
  end
end