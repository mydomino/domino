require 'rails_helper'


RSpec.feature "Views all of their stores" do
  let!(:store) { FactoryGirl.create(:dashboard, concierge: concierge) }
  let(:concierge) { FactoryGirl.create(:concierge) }
  scenario "through the web" do
    login_as(concierge, scope: :concierge)

    visit dashboards_path

    expect(page).to have_css('.dashboard-record', text: store.lead_name)
  end
end