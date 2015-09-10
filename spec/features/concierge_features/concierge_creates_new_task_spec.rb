require 'rails_helper'


RSpec.feature "Concierge creates a new task", type: :feature do
  let(:concierge) { FactoryGirl.create(:concierge) }
  scenario "by filling out the web form" do
    login_as(concierge, :scope => :concierge)

    visit new_task_path
    fill_in "Name", with: 'A Thing to be Done'
    fill_in "Description", with: 'Do the thing!'
    click_on "Save"

    expect(Task.all.size).to eq(1)
  end
end