require 'rails_helper'
require 'concierges_controller'
include Devise::TestHelpers


describe ConciergesController do

  it 'responds succesfully to editing a concierge' do
    sign_in(FactoryGirl.create(:concierge))

    get :edit

    expect(response).to have_http_status(:success)
  end

end