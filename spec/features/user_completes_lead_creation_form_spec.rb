require 'rails_helper'
require 'rack_session_access/capybara'

WebMock.disable_net_connect!(:allow => "127.0.0.1")

RSpec.feature "User completes lead creation form", :type => :feature, :js => true do
  scenario "with valid data and expects form to be disabled" do
    visit getstarted_path

    fill_in "lead_first_name", with: Faker::Name.first_name
    fill_in "lead_last_name", with: Faker::Name.last_name
    fill_in "lead_email", with: Faker::Internet.email
    fill_in "lead_phone", with: Faker::PhoneNumber.phone_number
    find('form input[type="submit"]').click 

    expect(page).to have_css('form', visible: false)
    expect(page).not_to have_css('.errors li')
    expect(page).to have_css('.success', visible: true)
  end
  scenario "without any data" do

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
RSpec.feature "gclid is captured as adwords", :type => :feature do
  scenario "with a gclid set" do
    visit '/?gclid=l3421j32kl4j3214oij324'
    
    visit getstarted_path
    
    expect(page.get_rack_session_key('campaign')).to eq('adwords')
  end
end