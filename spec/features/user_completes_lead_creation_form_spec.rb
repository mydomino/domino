require 'rails_helper'
require 'rack_session_access/capybara'
require 'helpers/zoho_mock'
WebMock.disable_net_connect!(:allow => "127.0.0.1")

RSpec.feature "User completes lead creation form", :type => :feature, :js => true do
  scenario "with valid data and expects form to be disabled" do
    visit getstarted_path

    fill_in "lead_email", with: "josh@mydomino.com"
    fill_in "lead_phone", with: "6078575974"
    find('form button[type="submit"]').click 

    expect(page).to have_css('button[disabled]')
    expect(page).to have_css('.reserve.submitted')
  end
  scenario "with invalid data" do

    visit getstarted_path
    find('form button[type="submit"]').click 

    expect(page).to have_css('.errors li', text: "Email can't be blank")
  end
end
RSpec.feature "utm_campaign is properly captured", :type => :feature do
  scenario "with a utm_campaign set" do
    visit '/?utm_campaign=my_campaign'
    
    visit getstarted_path
    
    expect(page.get_rack_session_key('campaign')).to eq('my_campaign')
  end
end