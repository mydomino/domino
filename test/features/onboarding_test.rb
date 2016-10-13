require 'test_helper'

feature "Can Access Home" do
  scenario "has content" do
    visit root_path
    page.must_have_content "MyDomino"
  end
end