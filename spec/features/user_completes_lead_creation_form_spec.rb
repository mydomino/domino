require 'rails_helper'
require 'rack_session_access/capybara'
require 'helpers/zoho_mock'
WebMock.disable_net_connect!(:allow => "127.0.0.1")

RSpec.feature "User completes lead creation form", :type => :feature, :js => true do
  scenario "with valid data and expects form to be disabled" do
    visit getstarted_path

    fill_in "lead_email", with: "josh@mydomino.com"
    fill_in "lead_phone", with: "6078575974"
    find('form input[type="submit"]').click 

    expect(page).to have_css('form', visible: false)
    expect(page).not_to have_css('.errors li')
    expect(page).to have_css('.success', visible: true)
  end
  scenario "with invalid data" do

    visit getstarted_path
    find('form input[type="submit"]').click 

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