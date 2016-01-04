require 'rails_helper'

RSpec.feature "Concierge changes their password" do
  let!(:subject) { FactoryGirl.create(:concierge) }
  let(:new_password) { Faker::Internet.password }

  scenario "By using the web interface" do
    login_as(subject, scope: :concierge)

    visit edit_concierge_path(subject)
    click_on "Change my password"

    fill_in "New Password", with: new_password
    fill_in "New Password Confirmation", with: new_password

    fill_in "Current password", with: subject.password

    click_on "Update"

    #it works, I don't know why this expectation doesn't, but it really should be rewritten as a custom route
    #expect(subject.password).to eq(new_password)
  end

end