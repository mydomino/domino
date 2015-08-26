require 'rails_helper'

RSpec.feature "Concierge makes a new recommendation for a user", :type => :feature do
  scenario "to buy a product from Amazon" do
    visit new_recommendation_path
  end
end