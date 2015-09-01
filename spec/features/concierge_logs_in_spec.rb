require 'rails_helper'


RSpec.feature "Concierge logs in", :type => :feature do

  let(:concierge) { FactoryGirl.create(:concierge) }

  scenario "by using a valid email and password", focus: true do 
    visit new_concierge_session_path
    fill_in "Email", with: concierge.email
    fill_in "Password", with: concierge.password
    click_on "Log in"

    
    expect(current_path).to eq(amazon_products_path)
  end
end