require 'rails_helper'
require 'leads_controller'

describe LeadsController do
  it 'adds browser info to session' do
    get :new

    expect(session[:browser]).to eq('Rails Testing')
  end
end