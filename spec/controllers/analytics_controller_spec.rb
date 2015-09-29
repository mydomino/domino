require 'rails_helper'
require 'analytics_controller'
include Devise::TestHelpers

describe AnalyticsController do

  it 'requires login' do
    expect { get :show }.to raise_error("undefined method `authenticate!' for nil:NilClass")
  end

  it 'renders if a concierge is logged in' do
    sign_in(FactoryGirl.create(:concierge))
    
    get :show

    expect(response).to have_http_status(:success)
  end

end