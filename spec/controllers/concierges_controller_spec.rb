require 'rails_helper'
require 'concierges_controller'

describe ConciergesController do

  let(:concierge) { double('concierge') }

  before(:each) do
    allow(request.env['warden']).to receive(:authenticate!).and_return(concierge)
    allow(controller).to receive(:current_concierge).and_return(concierge)
  end

  it 'responds succesfully to editing a concierge' do
    get :edit

    expect(response).to have_http_status(:success)
  end

end