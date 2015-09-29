require 'rails_helper'
require 'analytics_controller'

describe AnalyticsController do

  it 'requires login' do
    expect { get :show }.to raise_error("undefined method `authenticate!' for nil:NilClass")
  end

  it 'renders if a concierge is logged in' do
    concierge = double('concierge')
    allow(request.env['warden']).to receive(:authenticate!).and_return(concierge)
    allow(controller).to receive(:current_concierge).and_return(concierge)
    
    get :show

    expect(response).to have_http_status(:success)
  end

end