require 'rails_helper'
WebMock.disable_net_connect!(:allow => "127.0.0.1")

RSpec.feature "User clicks submit button twice", :type => :feature, :js => true do
  scenario "With valid data" do

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
  end

end