require 'rails_helper'


RSpec.feature "Concierge logs in", :type => :feature do

  let(:concierge) { FactoryGirl.create(:concierge) }

  scenario "by using a valid email and password" do 
    visit new_concierge_session_path
    fill_in "Email", with: concierge.email
    fill_in "Password", with: concierge.password
    click_on "Enter"
    
    expect(current_path).to eq(amazon_storefronts_path)
  end
end