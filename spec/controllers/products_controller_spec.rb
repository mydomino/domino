require 'rails_helper'
require 'products_controller'
include Devise::TestHelpers

describe ProductsController do

  before(:each) do
    sign_in FactoryGirl.create(:concierge)
  end

  it 'responds to something' do
    get :new

    expect(response).to have_http_status(:success)
  end

end