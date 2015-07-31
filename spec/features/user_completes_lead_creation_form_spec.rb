require 'rails_helper'
require 'rack_session_access/capybara'
WebMock.disable_net_connect!(:allow => "127.0.0.1")

RSpec.feature "User completes lead creation form", :type => :feature, :js => true do
  scenario "with valid data and expects form to be disabled" do
    response_body = <<-XML
<?xml version="1.0" encoding="UTF-8" ?>
<response uri="/crm/private/xml/Leads/insertRecords"><result><message>Record(s) added successfully</message><recorddetail><FL val="Id">1189990000000581013</FL><FL val="Created Time">2015-07-27 22:41:14</FL><FL val="Modified Time">2015-07-27 22:41:14</FL><FL val="Created By"><![CDATA[Gorman]]></FL><FL val="Modified By"><![CDATA[Gorman]]></FL></recorddetail></result></response>
XML
    WebMock.stub_request(:post, "https://crm.zoho.com/crm/private/xml/Leads/insertRecords").
      to_return(:status => 200, :body => response_body, :headers => {})

    visit getstarted_path

    fill_in "email", with: "josh@mydomino.com"
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
RSpec.feature "Lead captures utm_campaign", :type => :feature do
  scenario "with a utm_campaign set" do
    visit '/?utm_campaign=my_campaign'
    
    visit getstarted_path
    
    expect(page.get_rack_session_key('campaign')).to eq('my_campaign')
  end
end