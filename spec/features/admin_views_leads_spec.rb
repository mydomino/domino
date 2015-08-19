require 'rails_helper'

RSpec.feature "Admin views leads", :type => :feature do
  scenario "with at least one lead" do
    FactoryGirl.create(:lead)

    visit leads_path
  end
end